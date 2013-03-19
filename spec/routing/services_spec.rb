require 'spec_helper'

describe ServicesController do
  it do
    should route(:get, '/services').
      to(controller: 'services', action: :index)
  end

  it do
    should route(:get, '/services/1').
      to(action: :show, id: '1')
  end

  it do
    should route(:get, '/services/new').
      to(action: :new)
  end

  it do
    should route(:post, '/services').
      to(action: :create)
  end

  it do
    should route(:get, '/services/1/edit').
      to(action: :edit, id: '1')
  end

  it do
    should route(:put, '/services/1').
      to(action: :update, id: '1')
  end

  it do
    should route(:delete, '/services/1').
      to(action: :destroy, id: '1')
  end
end
