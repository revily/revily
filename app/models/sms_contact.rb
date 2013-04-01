# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  label            :string(255)
#  type             :string(255)
#  contactable_id   :integer
#  contactable_type :string(255)
#  address          :string(255)
#  uuid             :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SmsContact < Contact
  def trigger_message
    "#{@event.message}\n#{response_options}"
  end

  def acknowledge_message
    "All incidents assigned to you were acknowledged."
  end

  def resolve_message
    "All incidents assigned to you were resolved."
  end

  def unknown_message
    "I did not understand your response. ACKNOWLEDGE: 4, RESOLVE: 6, ESCALATE: 8"
  end

  def failure_message
    "The incidents assigned to you could not be #{action}d."
  end

  def notify(action, event)
    @event = event

    $twilio.account.sms.messages.create(
      from: Figaro.env.twilio_number,
      to: address,
      body: self.send("#{action}_message")
    )
  end
end
