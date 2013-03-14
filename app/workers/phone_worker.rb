class PhoneWorker
  include Sidekiq::Worker

  def perform(alert_id)
    alert = Alert.find(alert_id)
  end
  
end