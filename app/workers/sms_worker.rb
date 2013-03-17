class SMSWorker
  include Sidekiq::Worker

  def perform(alert_id)
    alert = Alert.find(alert_id)
    user = alert.event.service.current_user

    $twilio.account.sms.messages.create(
      from: Figaro.env.twilio_number,
      to: user.id
    )
  end
  
end