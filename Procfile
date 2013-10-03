web: bundle exec unicorn -p 9001 -c config/unicorn.rb
tunnel: forward 9001
worker: bundle exec sidekiq -c 4 -e development -q default -q incidents -q log -q test
#cron: bundle exec clockwork lib/clockwork.rb
