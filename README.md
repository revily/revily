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

## Deployment

* [Heroku](https://github.com/revily/revily/wiki/Heroku)

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
* `REVILY_REDIS_CACHE_URL ` - URI to redis instance (ex: `redis://localhost:6379/0/cache`)

The following variables are optional
* `MAILGUN_API_KEY` - Mailgun API key
* `MAILGUN_DOMAIN` - Mailgun domain

## Installation

For manual instructions, consult the [INSTALL.md](INSTALL.md) documentation.

### TL;DR

```bash
export RAILS_ENV=production TWILIO_ACCOUNT_SID=... TWILIO_AUTH_TOKEN=...
rake revily:setup revily:bootstrap revily:twilio:bootstrap
```

### Bootstrapping Revily

Two rake tasks are used to setup the initial configuration. The `revily:setup` task will create a database user, create a production database, and run all migrations. The `revily:bootstrap` task
will create your first account, user and print out environment variables which can be used to configure the application further.

```bash
export RAILS_ENV=production
rake revily:setup
rake revily:bootstrap
```

### Creating a Twilio account

A rake task is provided for automating the creation of a Twilio application, a phone number for voice and SMS messages, and configuring the number to use the Twilio application. You will need to know your account SID and your auth token, both of which you can find on the [Twilio dashboard](https://www.twilio.com/user/account).

```bash
export RAILS_ENV=production TWILIO_ACCOUNT_SID=... TWILIO_AUTH_TOKEN=...
rake revily:twilio:bootstrap
```

## Deployment

## HISTORY

https://github.com/revily/revily/commits/master

## BUGS

https://github.com/revily/revily/issues?state=open

## COPYRIGHT

Revily is Copyright &copy; Applied Awesome LLC.

## SEE ALSO

[pagerduty(1)](http://pagerduty.com), [opsgenie(1)](http://opsgenie.com), [victorops(1)](http://victorops.com/)
