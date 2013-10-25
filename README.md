# Revily

[![Build Status](https://secure.travis-ci.org/revily/revily.png?branch=master)](https://travis-ci.org/revily/revily)
[![Code Climate](https://codeclimate.com/github/revily/revily.png)](https://codeclimate.com/github/revily/revily)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/revily/revily/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/df59799a89c2ecdad827f45ea3f19762 "githalytics.com")](http://githalytics.com/revily/revily)

## Description

Revily is an on-call management and incident response service. Revily sends alerts right to your phone, route to the right person with flexible on-call scheduling, and fully integrates with your services using a powerful API.

# Dependencies

## Data storage

* [PostgreSQL](http://www.postgresql.org/) 9.x (application data)
* [Redis](http://redis.io/) (background processing; caching; session store)

Configuring these services is left as an exercise for the reader. You'll want at least one Postgres database, and up to three Redis databases (though, a single namespaced Redis instance will suffice).

## 3rd-Party Services

* [Twilio](http://www.twilio.com/) (voice and SMS communication)
* [Mailgun](http://www.mailgun.com/) (email receiving and parsing)

## Options

## Configuration

Revily makes extensive use of environment variables for configuring various parts of the system. The following variables are required:

* `SECRET_TOKEN` - generate with `rake secret`. Must be at least 30 characters long.
* `TWILIO_ACCOUNT_SID` - found at https://www.twilio.com/user/account
* `TWILIO_AUTH_TOKEN` - found at https://www.twilio.com/user/account
* `TWILIO_APPLICATION_SID` - found at https://www.twilio.com/user/account/apps
* `TWILIO_NUMBER` - found at https://www.twilio.com/user/account/phone-numbers/incoming
* `MAILER_URL` - default URL for mailing.
* `MAILER_DELIVERY_METHOD` - options: mailgun, smtp
* `MAILER_SENDER` - the email address from which Revily will send emails
* `NEWRELIC_ENABLE` - whether to enable New Relic. Set to "false" if it's not needed.
* `REVILY_REDIS_CACHE_URL ` - URI to redis instance (ex: `redis://localhost:6379/0/cache`)

The following variables are optional
* `MAILGUN_API_KEY` - Mailgun API key
* `MAILGUN_DOMAIN` - Mailgun domain
* `NEWRELIC_LICENSE_KEY` - New Relic license key. Only used if NEWRELIC_ENABLE is true.

## Deployment

## HISTORY

https://github.com/revily/revily/commits/master

## BUGS

https://github.com/revily/revily/issues?state=open

## COPYRIGHT

Revily is Copyright &copy; Applied Awesome LLC.

## SEE ALSO

[pagerduty(1)](http://pagerduty.com), [opsgenie(1)](http://opsgenie.com), [victorops(1)](http://victorops.com/)
