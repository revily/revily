class V1::ContactsController < V1::ApplicationController
  respond_to :json

  # doorkeeper_for :all, scopes: [ :read, :write ]
  before_action :authenticate_user!
  before_action :user
  before_action :contacts

  def sort
    params[:contacts].each_with_index do |id, index|
      Contact.update_all({ position: index + 1}, { id: id })
    end
    render nothing: true
  end

  def index
    @contacts = contacts.page(params[:page])
    respond_with @contacts
  end

  def show
    @contact = contacts.find_by!(uuid: params[:id])

    respond_with @contact
  end

  def new
    @contact = contacts.new

    respond_with @contact
  end
  
  def create
    @contact = contacts.new(contact_params)
    @contact.account = current_account
    @contact.save

    respond_with @contact, location: contact_url(@contact)
  end

  def update
    @contact = contacts.find_by_uuid!(params[:id])
    @contact.update_attributes(contact_params)

    respond_with user, @contact
  end

  def destroy
    @contact = contacts.find_by!(uuid: params[:id])
    @contact.destroy

    respond_with user, @contact
  end

  private

  def contact_params
    contact_params = params.permit(:label, :address, :type)
    contact_params[:type] = "Contact::#{contact_params[:type].classify}" if contact_params[:type]

    contact_params
  end

  def user
    @user = User.find_by!(uuid: params[:user_id]) if params[:user_id]
  end

  def contacts
    @contacts = @user.contacts
  end
end
