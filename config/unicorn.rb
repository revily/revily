rails_env  = ENV['RAILS_ENV'] || 'production'
rails_root = File.dirname(__FILE__) + "/.."

deploy_to    = File.expand_path(File.dirname(__FILE__)) + "/.."
current_path = deploy_to
shared_path  = "#{deploy_to}/../shared"

worker_processes  (rails_env == 'production' ? 12 : 1)
working_directory current_path

timeout 60

preload_app true

if rails_env != 'development'
  stdout_path  = "#{rails_root}/log/unicorn-stdout.log"
  stderr_path  = "#{rails_root}/log/unicorn-stderr.log"
end
