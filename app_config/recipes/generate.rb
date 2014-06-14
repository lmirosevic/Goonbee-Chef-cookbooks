require 'yaml'
require 'json'

node[:deploy].each do |application, deploy|
  if deploy && deploy[:configs]
    deploy[:configs].each do |config_name, config_object|
      # determine path for settings file
      app_root = "#{deploy[:deploy_to]}/shared"
      filename = File.join(app_root, config_object[:path])

      # write config to file
      file filename do
        mode '0660'
        group deploy[:group]
        owner deploy[:user]
        action :create

        case config_object[:type]
        when 'yaml'
          content config_object[:data].to_hash.to_yaml
        when 'json'
          content config_object[:data].to_json
        else
          raise 'Invalid config type used, currently supports "yaml" and "json"'
        end

        only_if do
          File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
        end
      end

      # restart the app
      if deploy[:application_type] == 'rails'
        # restart rails app
        notifies :run, "execute[restart Rails app #{application}]"
      elsif deploy[:application_type] == 'nodejs'
        # restart node app
        ruby_block "restart node.js application #{application}" do
          block do
            Chef::Log.info("restart node.js via: #{node[:deploy][application][:nodejs][:restart_command]}")
            Chef::Log.info(`#{node[:deploy][application][:nodejs][:restart_command]}`)
            $? == 0
          end
        end
      end
    end
  end
end

# Sample Chef JSON
#
# {
#   "deploy": {
#     "app_name": {
#       "configs": {
#         "settings": {                                 # config name
#           "type": "yaml",                               # type of config can be: yaml, json
#           "path": "/config/settings.yml",               # path where to write config to, relative to app root
#           "data": {                                     # data to write to config file
#             "app": {
#               "concurrency": 8,
#               "name": "...",
#             },
#             "new_relic": {
#               "app_name": "...",
#               "license_key": "...",
#               "log": "stdout"
#             },
#             "aws": {
#               "access_key_id": "...",
#               "secret_access_key": "..."
#             },
#             # ...
#           }
#         }
#       } 
#     }
#   }
# }
