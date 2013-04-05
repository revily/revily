class AccountsController < ApplicationController

  before_filter :require_no_authentication, :only => [ :new, :create ]
  
  def new

  end

  def create

  end
end