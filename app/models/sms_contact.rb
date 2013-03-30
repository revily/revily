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
  def action_message
    "Press 4 to ACKNOWLEDGE, 6 to RESOLVE, 8 to ESCALATE"
  end

  def body
    message = ""
    message += @event.message
    message += "\n"
    message += "ACKNOWLEDGE: 4, RESOLVE: 6, ESCALATE: 8"
  end

  def notify(event)
    @event = event

    $twilio.account.sms.messages.create(
      from: Figaro.env.twilio_number,
      to: self.address,
      body: self.body
    )
  end
end
