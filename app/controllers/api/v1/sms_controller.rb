class Api::V1::SmsController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token

  respond_to :json

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