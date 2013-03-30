class Api::V1::SmsController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def receive
    body = params['Body'].to_i
    from = params['From']

    @user = Contact.where("address LIKE ?", "%#{from}%").first.contactable

    action = case body
    when "4"
      :acknowledge
    when "6"
      :resolve
    when "8"
      :escalate
    else
      nil
    end



    render :json => @user
  end

end 