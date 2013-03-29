require 'spec_helper'

describe EventsController do
  it { should route(:get, '/services/1/events').to(action: :index, service_id: '1') }
  it { should route(:get, '/events/1').to(action: :show, id: '1') }
  it { should route(:get, '/events/1').to(action: :show, id: '1') }
  it { should route(:get, '/services/1/events/new').to(action: :new, service_id: '1') }
  it { should route(:post, '/services/1/events').to(action: :create, service_id: '1') }
  it { should route(:get, '/events/1/edit').to(action: :edit, id: '1') }
  it { should route(:put, '/events/1').to(action: :update, id: '1') }
  it { should route(:delete, '/events/1').to(action: :destroy, id: '1') }
end
