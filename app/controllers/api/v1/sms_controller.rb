class Api::V1::SmsController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def send_sms
    @event = Event.find_by_uuid(params[:event_id])

    @user = User.find_by_uuid(params[:id])
    @user.sms_contacts.each do |contact|
      $twilio.account.sms.messages.create(
        from: Figaro.env.twilio_number,
        to: contact.address,
        body: "Please press 4"
      )

    end

    render :json => params
  end

  def receive_sms
    body = params['Body']
    from = params['From']
    @user = Contact.find_by_address(from).first

    render :json => params
  end

end 