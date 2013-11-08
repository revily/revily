require_relative "common"
require "twilio-ruby"

namespace "revily:twilio" do

  desc "Bootstrap Twilio acccount, number, and application setup"
  task :bootstrap => [ :create_application, :create_number ] do
    success "Done configuring Twilio for your Revily application"
    say <<-EOF

Use these environment variables:

TWILIO_ACCOUNT_SID="#{ENV['TWILIO_ACCOUNT_SID']}"
TWILIO_AUTH_TOKEN="#{ENV['TWILIO_AUTH_TOKEN']}"
TWILIO_APPLICATION_SID="#{ENV['TWILIO_APPLICATION_SID']}"
TWILIO_NUMBER="#{ENV['TWILIO_NUMBER']}"

EOF
  end

  # desc "Create a Twilio application"
  task :create_application => :validate do
    revily_url = ask "Enter the public URL endpoint of your Revily application: "
    info "Creating a new Twilio application..."
    app = client.account.applications.create(
      friendly_name: "Revily",
      voice_url: "#{revily_url}/voice",
      voice_fallback_url: "#{revily_url}//apivoice/fallback",
      status_callback: "#{revily_url}/voice/callback",
      sms_url: "#{revily_url}/api/sms",
      sms_fallback_url: "#{revily_url}/api/sms/fallback",
      sms_status_callback: "#{revily_url}/api/sms/callback"
    )

    ENV["TWILIO_APPLICATION_SID"] = app.sid
  end

  # desc "Create a local Twilio number for a specific country"
  task :create_number => :validate do
    info "Creating a new Twlio phone number..."
    country_code
    area_code
    info "Fetching a list of available numbers..."
    numbers = client.account.available_phone_numbers.get(country_code).local.list(
      area_code: area_code,
      voice_enabled: true,
      sms_enabled: true
    )

    if numbers.length == 0
      error "No numbers available. Try with different settings."
      exit 1
    end

    # Limit to 10 numbers
    phone_number = cli.choose do |menu|
      menu.prompt = "Select your desired number"
      numbers[0..9].each do |num|
        menu.choice num.phone_number
      end
    end

    info "Creating number #{phone_number}..."
    client.account.incoming_phone_numbers.create(
      phone_number: phone_number,
      voice_application_sid: ENV["TWILIO_APPLICATION_SID"],
      sms_application_sid: ENV["TWILIO_APPLICATION_SID"]
    )
    ENV["TWILIO_NUMBER"] = phone_number
  end

  task :validate => :environment do
    %w[ TWILIO_ACCOUNT_SID TWILIO_AUTH_TOKEN ].each do |var|
      if ENV[var].empty?
        error "You must set the #{var} environment variable."
        exit 1
      end
    end
  end

end

def client
  @client ||= Twilio::REST::Client.new(ENV["WILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])
end

def area_code
  ENV["AREA_CODE"] ||= ask "Enter your desired area code: " do |q|
    q.validate = /\d+/
  end
end

def country_code
  ENV["COUNTRY"] ||= choose do |menu|
    menu.prompt = "Select your country (default: US): "
    menu.default = "US"
    menu.choices "US", "CA"
  end
end
