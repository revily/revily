class Web::ContactsController < Web::ApplicationController
  before_action :authenticate_user!
  before_action :user
  before_action :contact, only: [ :update, :destroy ]

  def create
    @contact = user.contacts.new(contact_params)

    if @contact.save
      flash[:notice] = "Contact was successfully created."
    else
      flash[:alert] = "Contact could not be created."
    end

    respond_with @contact
  end

  def update
    if @contact.update(contact_params)
      flash[:notice] = "Contact was successfully updated."
    else
      flash[:alert] = "Contact could not be updated."
    end

    respond_with user, @contact, location: user_path(user)
  end

  def destroy
    if @contact.destroy
      flash[:notice] = "Contact was successfully deleted."
    else
      flash[:alert] = "Contact could not be deleted."
    end

    respond_with @contact
  end

  private

  def user
    @user = User.find_by(uuid: params[:id])
  end

  def contact
    @contact = user.contacts.find_by(uuid: params[:id])
  end

  def contact_params
    params.require(:contact).permit(:address, :label, :type)
  end
end
