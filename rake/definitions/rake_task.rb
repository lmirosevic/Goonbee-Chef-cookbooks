define :rake_task, :task => nil, :application => nil do
  if (params[:task].kind_of?(Array) || params[:task].kind_of?(String)) && (params[:application] && node[:deploy][params[:application]])
    tasks = params[:task].kind_of?(Array) ? params[:task] : [params[:task]]#if it's just a single task, wrap it in an array
    deploy = node[:deploy][params[:application]]
    commands = tasks.map{ |rake_task| "#{deploy[:rake]} #{rake_task}" }
    bundler_commands = commands.map{ |command| "/usr/local/bin/bundle exec #{command}" }

    execute "Run rake tasks: #{tasks.inspect} for application: #{params[:application]}" do      
      command "if [ -f Gemfile ]; then echo 'OpsWorks: Gemfile found - running rake task with bundle exec' && #{bundler_commands.join(' && ')}; else echo 'OpsWorks: no Gemfile - running plain rake task' && #{commands.join(' && ')}; fi"
      cwd deploy[:current_path]
      environment (deploy[:environment] || {}).merge(deploy[:env_vars] || {})
      action :run
    end
  end
end
