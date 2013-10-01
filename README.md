# Revily

## NAME

Revily - It wakes you up!

[![Build Status](https://secure.travis-ci.org/revily/revily.png?branch=master)](https://travis-ci.org/revily/revily)
[![Code Climate](https://codeclimate.com/github/revily/revily.png)](https://codeclimate.com/github/revily/revily)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/revily/revily/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

## DESCRIPTION

Revily is (going to be) a clone of popular on-call management and incident response applications.

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

Revily is Copyright &copy; 2013 Dan Ryan <hi@iamdanryan.com>

## SEE ALSO

[pagerduty(1)](http://pagerduty.com), [opsgenie(1)](http://opsgenie.com)
