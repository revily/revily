## Features

* add mail notifications
* add email parsing
* add flipper for setting features (https://github.com/jnunemaker/flipper)
* replace active_attr with virtus now that 1.0.0 has been released


* add oauth
  - rate limiting - https://github.com/applicake/doorkeeper/wiki/Rate-limit-with-Redis
  - admin superuser
    - customize acts_as_tenant to allow admin to get to any account

* add admin account
  - adding rails_admin support
  - routing constraints for /admin and /sidekiq


* add LDAP auth

## Refactor

* move voice and sms controllers to separate, mountable apps (grape? vanilla sinatra?)
* redo handlers
  - event list and matchers are very slow
* rewrite UserSchedule. look into caching values
* moar service objects! Look at travis-ci/travis-core for inspiration
* move notification logic out of contact classes

## Chores

* add missing specs:
  - event changeset
  - 
* sidekiq:
  - log job class



# DONE

## Features
* add periscope for awesome custom filtering: https://github.com/laserlemon/periscope

## Refactors
* improve state machine code.

## Chores
* move concerns back to models/controllers
* removed eventable?, publishable?, etc. from Identifiable
