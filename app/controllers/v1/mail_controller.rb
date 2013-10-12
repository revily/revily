class V1::MailController < V1::ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_tenant

  def receive
    logger.info ap request.env['REMOTE_ADDR']

    render nothing: true
  end

  def cloudmailin
    receiver = MultiMail::Receiver.new({ provider: 'cloudmailin' })
  end

  def mandrill
    receiver = MultiMail::Receiver.new({ provider: 'mandrill' })
  end

  def postmark
    receiver = MultiMail::Receiver.new({ provider: 'postmark' })
  end

  def sendgrid
    receiver = MultiMail::Receiver.new({ provider: 'sendgrid' })
  end

  private

  def get_service_from_email(address)
  end
end
