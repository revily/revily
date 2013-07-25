class SMSWorker
  include Sidekiq::Worker

  def perform(alert_id)
    alert = Alert.find(alert_id)
    user = alert.incident.service.current_user

    $twilio.account.sms.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: user.id
    )
  end
  
end