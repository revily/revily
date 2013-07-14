class Hook < ActiveRecord::Base
  belongs_to :account
  
  serialize :config, JSON
  serialize :events, JSON
end
