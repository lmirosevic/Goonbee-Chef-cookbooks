node[:deploy].each do |application, deploy|
  default[:deploy][application][:deploy_to] = "/srv/www/#{application}"
  default[:deploy][application][:current_path] = "#{node[:deploy][application][:deploy_to]}/current"
  
  if File.exists?('/usr/local/bin/rake')
    # local Ruby rake is installed
    default[:deploy][application][:rake] = '/usr/local/bin/rake'
  else
    # use default Rake/ruby
    default[:deploy][application][:rake] = 'rake'
  end

  default[:deploy][application][:rails_env] = 'production'
  default[:deploy][application][:environment] = {"RAILS_ENV" => deploy[:rails_env],
                                                 "RUBYOPT" => "",
                                                 "RACK_ENV" => deploy[:rails_env]}

end
