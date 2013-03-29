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
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class PhoneContact < Contact
  # attr_accessible :title, :body
end
