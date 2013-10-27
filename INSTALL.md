# Dependencies

* [PostgreSQL](http://www.postgresql.org/) >= 9.2 (application data)
* [Redis](http://redis.io/) >= 2.6 (background processing; caching; session store)

Configuring these services is left as an exercise for the reader. You'll want at least one Postgres database, and up to three Redis databases (though, a single namespaced Redis instance will suffice).

# 3rd-Party Services

* [Twilio](http://www.twilio.com/) (voice and SMS communication)
* [Mailgun](http://www.mailgun.com/) (email receiving and parsing)

## Twilio

Revily uses Twilio for all phone and SMS-based notifications. Fortunately, Twilio offers utility-style billing, so you'll only ever pay $1 per phone number, and only for notifications you send. Sounds like an incentive to avoid getting paged!

You'll need a Twilio account to get started. Once you've got one, you can configure the remaining parts necessary to get Revily working with Twilio. Head to https://www.twilio.com/try-twilio and come back here when you're done.

### Account credentials

We need the Twilio Account SID and the Auth Token from your Twilio account. [Get these from your dashboard](https://www.twilio.com/user/account).

### Creating a TwiML application

Go to the [Create App](https://www.twilio.com/user/account/apps/add) page. Give it a name, choose the optional settings to view extra configuration parameters, and for each option add the following (substituting $REVILY_URL for the publicly-accessible URL to your Revily service):

#### Voice

* Request URL: `$REVILY_URL/voice - POST`
* Fallback URL: `$REVILY_URL/voice/fallback - POST`
* Status Callback URL: `$REVILY_URL/voice/callback - POST`

#### Messaging

* Request URL `$REVILY_URL/sms - POST`
* Fallback URL: `$REVILY_URL/sms/fallback - POST`
* Status Callback URL: `$REVILY_URL/sms/callback - POST`

Save your changes, and [go back to the TwiML Apps index](https://www.twilio.com/user/account/apps). The long string underneath your application name is the Application SID. Write that down, we'll need it later.

### Buying a phone number

You need a phone number from which you'll be making phone calls and sending text messages. [Purchase a phone number](https://www.twilio.com/user/account/phone-numbers/available/local), and make sure the number you select works for both Voice and Text.

### Setting up a phone number

Once you've purchased a phone number, you can configure it at Twilio to work with Revily. Go to [Manage Numbers](https://www.twilio.com/user/account/phone-numbers/incoming), then select the number you want to manage. 

Under both "Voice" and "Messaging", you should see your new application listed as an option in each dropdown menu (if you don't, make sure each top-right dropdown says "Application" and not "URLs"). Choose your application, and click on "Save Changes".

### Configuring Revily

Revily uses four environment variables for configuring Twilio:

* `TWILIO_ACCOUNT_SID` - found at https://www.twilio.com/user/account
* `TWILIO_AUTH_TOKEN` - found at https://www.twilio.com/user/account
* `TWILIO_APPLICATION_SID` - found at https://www.twilio.com/user/account/apps
* `TWILIO_NUMBER` - found at https://www.twilio.com/user/account/phone-numbers/incoming

* external
  - twilio
  - mailgun (for email parsing)

* dependencies
  - postgres
  - redis

* create .env file from sample


* create first user
* create a global oauth accounts:
  - one for users
  - one for services