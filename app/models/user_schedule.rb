class UserSchedule < ActiveRecord::Base
  include Identifiable

  belongs_to :schedule
  belongs_to :user
end
