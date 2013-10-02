class V1::SmsController < V1::ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_tenant

  respond_to :json

  def index
    logger.info ap params

    body = params['Body'].to_i
    from = params['From']

    user = Contact.includes(:user).where("address LIKE ?", "%#{from}%").first.user

    action = case body
    when 4
      'acknowledge'
    when 6
      'resolve'
    when 8
      'escalate'
    else
      nil
    end

    if action

      user.incidents.each do |incident|
        incident.send(action)
      end
    end

    render :json => @user
  end

  # TODO(dryan): do something with sms#callbackend
  def callback
    logger.info ap params
    head :ok
  end

  # TODO(dryan): do something with sms#fallback
  def fallback
    logger.info ap params
    head :ok
  end

  protected
  
  def current_actor
    @user
  end
end
