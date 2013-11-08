class ServicePolicy < ActiveRecord::Base
  include Identity
  
  belongs_to :service
  belongs_to :policy
end
