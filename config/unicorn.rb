rails_env  = ENV['RAILS_ENV'] || 'production'
rails_root = File.dirname(__FILE__) + "/.."

deploy_to    = File.expand_path(File.dirname(__FILE__)) + "/.."
current_path = deploy_to
shared_path  = "#{deploy_to}/../shared"

worker_processes  (rails_env == 'production' ? 12 : 1)
working_directory current_path

# important for Ruby 2.0
preload_app true

timeout 30

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

initialized = false
before_fork do |server, worker|

  unless initialized
    # get rid of rubbish so we don't share it
    GC.start
  end

  ActiveRecord::Base.connection.disconnect!

  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  sleep 1
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
