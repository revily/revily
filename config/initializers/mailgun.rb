require 'multi_mail/mailgun/sender'

ActiveSupport.on_load(:action_mailer) do
  ActionMailer::Base.add_delivery_method :mailgun,
                                         MultiMail::Sender::Mailgun,
                                         api_key: ENV['MAILGUN_API_KEY'],
                                         domain: ENV['MAILGUN_DOMAIN']
end
