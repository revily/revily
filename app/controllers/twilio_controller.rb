class TwilioController < ApplicationController
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def sms
    Rails.logger.info params.inspect
  end

  def phone
    Rails.info.logger params.inspect
  end

end 