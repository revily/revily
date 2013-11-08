module Tenancy
  extend ActiveSupport::Concern

  included do
    acts_as_tenant # belongs_to :account
  end
end
