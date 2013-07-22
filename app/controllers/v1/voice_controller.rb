class V1::VoiceController < V1::ApplicationController
  skip_before_action :verify_authenticity_token

  respond_to :json, :xml

  def send
    response = Twilio::TwiML.build do |res|
      res.say "el oh el"
      res.gather action: voice_receive_path, method: "POST" do |g|
        g.say "now hit some shit"
      end
      res.hangup
    end
    logger.info response.inspect
    render :xml => response
  end

  def receive
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

end
