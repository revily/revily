# == Schema Information
#
# Table name: user_schedules
#
#  id          :integer          not null, primary key
#  uuid        :string(255)      not null
#  schedule_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class UserSchedule < ActiveRecord::Base
  include Identifiable

  belongs_to :schedule
  belongs_to :user
end
