node[:rake_task].each do |application, task|
  rake_task "#{task} for application: #{application}" do
    task task
    application application
  end
end

# Chef JSON example:
#
# {
#   deploy: {
#     some_app: {
#     }
#   },
#   rake_task: {
#     some_app: ['db:migrate']
#   }
# }
