require 'json'

node[:deploy].each do |application, deploy|
  #write the configuration file, we use this so that unicorn can pull these out when needed during hot restarts
  file "#{deploy[:deploy_to]}/shared/config/environment.json" do
    content JSON.generate(deploy[:env_vars] || {})
    mode "0755"
    owner deploy[:user]
    group deploy[:group]
    action :create
  end

  execute "restart Rails app #{application} for env update" do
    cwd deploy[:current_path]
    environment deploy[:environment].merge(deploy[:env_vars] || {})
    command node[:opsworks][:rails_stack][:restart_command]
    action :run
  end
end
