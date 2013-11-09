class ServicePolicy < ActiveRecord::Base
  include Identity

  # @!group Associations
  belongs_to :service
  belongs_to :policy
  # @!endgroup
  
end
