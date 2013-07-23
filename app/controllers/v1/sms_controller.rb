class V1::SmsController < V1::ApplicationController
  skip_before_action :verify_authenticity_token

  respond_to :json

  def receive
    logger.info ap params

    body = params['Body'].to_i
    from = params['From']

    contact = Contact.where("address LIKE ?", "%#{from}%").first
    user = contact.contactable

    action = case body
    when 4
      'acknowledge'
    when 6
      'resolve'
    when 8
      'escalate'
    else
      nil
    end

    if action
      user.incidents.each do |incident|
        incident.send(action)
      end
      Incident::NotifyContact.perform_async(action, contact.id)
    else
      Incident::NotifyContact.perform_async('unknown', contact.id)
    end

    render :json => @user
  end
  
  # TODO(dryan): do something with sms#callback
  def callback
    logger.info ap params
    head :ok
  end

  # TODO(dryan): do something with sms#fallback
  def fallback
    logger.info ap params
    head :ok
  end



end
