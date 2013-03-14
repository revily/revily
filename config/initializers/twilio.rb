$twilio = Twilio::REST::Client.new(Figaro.env.twilio_account_sid, Figaro.env.twilio_auth_token)
