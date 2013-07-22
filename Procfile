web: bundle exec unicorn -p $PORT
guard: bundle exec guard
tunnel: forward 5000
worker: bundle exec sidekiq -c 4 -e development -q *
#cron: bundle exec clockwork lib/clockwork.rb
