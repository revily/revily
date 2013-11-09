class Integration::VoiceController < Integration::ApplicationController
  respond_to :json

  skip_before_action :verify_authenticity_token
  skip_before_action :set_tenant
  before_action :user

  # Example POST:
  #
  # {
  #   "AccountSid" => "$TWILIO_ACCOUNT_SID",
  #   "ToZip" => "48864",
  #   "FromState" => "CA",
  #   "Called" => "+15172145853",
  #   "FromCountry" => "US",
  #   "CallerCountry" => "US",
  #   "CalledZip" => "48864",
  #   "Direction" => "outbound-api",
  #   "FromCity" => "SAN FRANCISCO",
  #   "CalledCountry" => "US",
  #   "CallerState" => "CA",
  #   "CallSid" => "CAa2ca794e2c2bba785d51ba2f9f0796cc",
  #   "CalledState" => "MI",
  #   "From" => "+14157671567",
  #   "CallerZip" => "94108",
  #   "FromZip" => "94108",
  #   "CallStatus" => "in-progress",
  #   "ToCity" => "LANSING",
  #   "ToState" => "MI",
  #   "To" => "+15172145853",
  #   "ToCountry" => "US",
  #   "CallerCity" => "SAN FRANCISCO",
  #   "ApiVersion" => "2010-04-01",
  #   "Caller" => "+14157671567",
  #   "CalledCity" => "LANSING",
  #   "format" => :json,
  #   "controller" => "v1/voice",
  #   "action" => "index"
  # }
  def index
    incident = user.incidents.unresolved.first
    service = incident.try(:service)

    twiml = Twilio::TwiML.build do |response|
      if incident && service
        response.say "Revily alert on #{service.name}:", voice: "man"
        response.say "#{incident.message}"
        response.gather action: voice_receive_path, method: "post", num_digits: 1 do |gather|
          gather.say "Press 4 to acknowledge, press 6 to resolve, or press 8 to escalate."
        end
      else
        response.say "You have no incidents. Goodbye!"
        response.hangup
      end
    end

    render xml: twiml
  end

  # call initiates, twilio POSTs to #respond to get instructions on how to respond
  # respond looks up user, determines the incidents assigned to user
  # and plays incident count, then alert: "message"
  # called chooses an option
  #
  # Example POST:
  #
  # {
  #   "AccountSid" => "$TWILIO_ACCOUNT_SID",
  #   "ToZip" => "48864",
  #   "FromState" => "CA",
  #   "Called" => "+15172145853",
  #   "FromCountry" => "US",
  #   "CallerCountry" => "US",
  #   "CalledZip" => "48864",
  #   "Direction" => "outbound-api",
  #   "FromCity" => "SAN FRANCISCO",
  #   "CalledCountry" => "US",
  #   "CallerState" => "CA",
  #   "CallSid" => "CA54f495d8fc7c4476a946f25f65889e23",
  #   "CalledState" => "MI",
  #   "From" => "+14157671567",
  #   "CallerZip" => "94108",
  #   "FromZip" => "94108",
  #   "CallStatus" => "in-progress",
  #   "ToCity" => "LANSING",
  #   "ToState" => "MI",
  #   "To" => "+15172145853",
  #   "Digits" => "4",
  #   "ToCountry" => "US",
  #   "msg" => "Gather End",
  #   "CallerCity" => "SAN FRANCISCO",
  #   "ApiVersion" => "2010-04-01",
  #   "Caller" => "+14157671567",
  #   "CalledCity" => "LANSING",
  #   "format" => :json,
  #   "action" => "receive",
  #   "controller" => "v1/voice"
  # }
  def receive
    response = voice_params["Digits"].to_i.to_s
    action, message = Contact::RESPONSE_MAP[response].values_at(:action, :message)

    user.incidents.unresolved.each { |incident| incident.send(action) && incident.save } if action

    twiml = Twilio::TwiML.build do |response|
      response.say message
      if action
        response.say "Goodbye!"
        response.hangup
      else
        response.redirect voice_path
      end
    end

    render xml: twiml
  end

  # TODO(dryan): do something with voice#callback
  def callback
    head :ok
  end

  # TODO(dryan): do something with voice#fallback
  def fallback
    head :ok
  end

  protected

  def user
    @user ||= User.joins(:phone_contacts).where("contacts.address LIKE ?", "%#{voice_params["To"]}%").first
  end

  def current_actor
    user
  end

  def voice_params
    params.permit(:Digits, :To)
  end

end
