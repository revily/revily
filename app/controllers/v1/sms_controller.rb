class V1::SmsController < V1::ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_tenant

  before_action :user

  respond_to :json, :xml

  # Example POST
  # {
  #   "AccountSid" => "ACa2b4e3abff33bdb254d43086255d84e1",
  #   "MessageSid" => "SMe8f5b77a33ad4b70e7865bce8a3bdc9a",
  #   "Body" => "3",
  #   "ToZip" => "94108",
  #   "ToCity" => "SAN FRANCISCO",
  #   "FromState" => "MI",
  #   "ToState" => "CA",
  #   "SmsSid" => "SMe8f5b77a33ad4b70e7865bce8a3bdc9a",
  #   "To" => "+14157671567",
  #   "ToCountry" => "US",
  #   "FromCountry" => "US",
  #   "SmsMessageSid" => "SMe8f5b77a33ad4b70e7865bce8a3bdc9a",
  #   "ApiVersion" => "2010-04-01",
  #   "FromCity" => "LANSING",
  #   "SmsStatus" => "received",
  #   "NumMedia" => "0",
  #   "From" => "+15172145853",
  #   "FromZip" => "48864",
  #   "format" => :json,
  #   "controller" => "v1/sms",
  #   "action" => "index"
  # }

  def index
    response = sms_params['Body'].to_i.to_s
    action = Contact::RESPONSE_MAP[response][:action]
    message = Contact::RESPONSE_MAP[response][:message]

    if action
      user.incidents.unresolved.each do |incident|
        incident.send(action)
      end
    end

    twiml = Twilio::TwiML.build do |res|
      if action
        res.message "#{message}"
      else
        res.message "Your response was invalid."
      end
    end

    render xml: twiml
  end

  # Example POST callback
  # {
  #   "AccountSid" => "ACa2b4e3abff33bdb254d43086255d84e1",
  #   "SmsStatus" => "sent",
  #   "Body" => "wat",
  #   "SmsSid" => "SM10922d7c152567151b11cef5c3f82922",
  #   "To" => "+15172145853",
  #   "From" => "+14157671567",
  #   "ApiVersion" => "2010-04-01",
  #   "format" => :json,
  #   "action" => "callback",
  #   "controller" => "v1/sms"
  # }
  # TODO(dryan): do something with sms#callbackend
  def callback
    head :ok
  end

  # TODO(dryan): do something with sms#fallback
  def fallback
    head :ok
  end

  protected

  def user
    @user ||= User.joins(:sms_contacts).where("contacts.address LIKE ?", "%#{sms_params['From']}%").first
  end

  def current_actor
    user
  end

  def sms_params
    params.permit(:Body, :From)
  end
end
