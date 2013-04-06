# Reveille

## NAME

Reveille - It wakes you up!

[![Build Status](https://secure.travis-ci.org/danryan/reveille.png?branch=master)](https://travis-ci.org/danryan/reveille)
[![Code Climate](https://codeclimate.com/github/danryan/reveille.png)](https://codeclimate.com/github/danryan/reveille)
[![Coverage Status](https://coveralls.io/repos/danryan/reveille/badge.png?branch=master)](https://coveralls.io/r/danryan/reveille)

## DESCRIPTION

Reveille is (going to be) a clone of popular on-call management and incident response applications.

## DEPENDENCIES

* [PostgreSQL](http://www.postgresql.org/) 9.x (application data)
* [Redis](http://redis.io/) (background processing)
* [Twilio](http://www.twilio.com/) (voice and SMS communication)

## OPTIONS

## ENVIRONMENT

## DEPLOYMENT

Configure `config/application.yml` with your credentials:

```yaml
SECRET_TOKEN: 2fad77b0cccfbadcd4616a336f0538b9
TWILIO_ACCOUNT_SID: ACa7aae08a4e2bcdaa3ad00797e6736021
TWILIO_AUTH_TOKEN: 7a777c79a299dddda93b523dee44d9fd
MAILER_URL: appliedawesome.com
```


### Heroku quick deploy

```bash
heroku create
rake figaro:heroku
git push heroku master
heroku run rake db:schema:load
```

## HISTORY

## BUGS

## COPYRIGHT

Reveille is Copyright &copy; 2013 Dan Ryan <hi@iamdanryan.com>

## SEE ALSO

[pagerduty(1)](http://pagerduty.com), [opsgenie(1)](http://opsgenie.com)