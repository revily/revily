class V1::VoiceController < V1::ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_tenant

  respond_to :json

  # Example POST:
  #
  # {
  #   "AccountSid" => "ACa2b4e3abff33bdb254d43086255d84e1",
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
    # to = params['To']
    # @contact = Contact.where("address LIKE ?", "%#{to}%").first
    # @user = @contact.contactable if @contact.present?
    contact = Contact.find_by(address: params['To'])
    logger.info ap contact
    logger.info ap params

    twiml = Twilio::TwiML.build do |res|
      res.say "Revily Alert on foobar", voice: 'man'
      res.gather action: voice_receive_path, method: 'POST', num_digits: 1 do |g|
        g.say "Press 4 to acknowledge, press 6 to resolve, or press 8 to escalate."
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
  #   "AccountSid" => "ACa2b4e3abff33bdb254d43086255d84e1",
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
    logger.info ap params

    contact = Contact.find_by(address: params['To'])
    user = contact.contactable

    response = params['Digits']
    action = response_map[response][:action]
    message = response_map[response][:message]

    if action
      user.incidents.each do |incident|
        incident.send(action)
      end
    end
    
    twiml = Twilio::TwiML.build do |res|
      res.say message
      if action
        res.say "Goodbye!"
        res.hangup
      else
        res.redirect voice_path
      end
    end

    render xml: twiml
  end

  def acknowledge
  end

  def resolve
  end

  def escalate
  end

  def unknown
  end

  def hangup

  end

  # TODO(dryan): do something with voice#callback
  def callback
    logger.info ap params
    head :ok
  end

  # TODO(dryan): do something with voice#fallback
  def fallback
    logger.info ap params
    head :ok
  end

  protected

    def response_map
      response_map = {
        '4' => { action: 'acknowledge', message: 'All incidents were acknowledged.' },
        '6' => { action: 'resolve', message: 'All incidents were resolved.' },
        '8' => { action: 'escalate', message: 'All incidents were escalated.'}
      }
      response_map.default = { action: nil, message: 'Your response was invalid.' }

      response_map
    end
end
