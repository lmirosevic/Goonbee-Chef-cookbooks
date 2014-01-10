require 'yaml'
require 'json'

node[:deploy].each do |app_name, app_config|
  app_config[:configs].each do |config_name, config_object|
    # determine path for settings file
    app_root = "#{app_config[:deploy_to]}/current"
    filename = File.join(app_root, config_object[:path])
    
    #write config to file
    file filename do
      mode "0660"
      group app_config[:group]
      owner app_config[:user]
      action :create

      case config_object[:type]
      when 'yaml'
        content config_object[:data].to_yaml
      when 'json'
        content config_object[:data].to_json
      else
        raise 'Invalid config type used, currently supports "yaml" and "json"'
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