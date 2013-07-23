class ServicePolicy < ActiveRecord::Base
  include Identifiable
  
  belongs_to :service
  belongs_to :policy
end
