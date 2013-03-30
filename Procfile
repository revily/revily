web: bundle exec unicorn -p $PORT
guard: bundle exec guard
tunnel: ssh  -nNt -g -R :12772:0.0.0.0:5000 tunnlr3517@ssh1.tunnlr.com
worker: bundle exec sidekiq -c 4 -e development
#cron: bundle exec clockwork lib/clockwork.rb
