## Features

* add periscope for awesome custom filtering: https://github.com/laserlemon/periscope
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
* redo hooks (both global and account-specific)
  - name attribute is confusingly used to set the handler
* redo handlers
  - event list and matchers are very slow
* rewrite UserSchedule. look into caching values
* improme state machine code.
  - look into using simple_states (https://github.com/svenfuchs/simple_states)
  - and using service objects over large code blocks

## Chores

* add missing specs:
  - event changeset
  - 