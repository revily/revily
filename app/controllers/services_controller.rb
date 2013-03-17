class ServicesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @services = Service.all
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
