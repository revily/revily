class ServicePolicy < ActiveRecord::Base
  include Revily::Concerns::Identifiable
  
  belongs_to :service
  belongs_to :policy
end
