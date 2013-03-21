require 'spec_helper'

describe 'Integration API' do
  let(:service) { create(:service) }
  let(:token) { service.authentication_token }

  before do
    header 'Authorization', %[Token token="#{token}"]
  end

  describe 'PUT /trigger' do
    let(:attributes) { attributes_for(:event) }

    context 'without key' do
      before do
        put '/trigger', attributes.to_json
      end

      it { should respond_with(:accepted) }
      it { should have_content_type(:json) }

      it 'creates an event' do
        service.should have(1).event
        body.should be_json_eql service.events.last.to_json
      end
    end

    context 'with key', focus: true do
      let(:attributes) { attributes_for(:event_with_key) }

      before do
        put '/trigger', attributes.to_json
      end

      it { should respond_with(:accepted) }
      it { should have_content_type(:json) }

      it 'creates an event' do
        puts body.inspect
        puts headers.inspect
        
        service.should have(1).event
        body.should be_json_eql service.events.last.to_json
      end
    end

    context 'with duplicate key' do
      let(:attributes) { attributes_for(:event_with_key) }
      let!(:event) { create(:event_with_key, service: service) }

      before do
        put '/trigger', attributes.to_json
      end

      it 'returns existing event' do
        new_event = service.events.where(key: attributes[:key]).first

        service.should have(1).event
        service.should_not have(2).events
        new_event.should eq event
      end
    end

    context 'with duplicate key but different message' do
      let(:attributes) { attributes_for(:event_with_key, message: "Different message!") }
      let!(:event) { create(:event_with_key, service: service, message: "Different message!") }
      
      before do
        put '/trigger', attributes.to_json
      end

      it 'returns existing event even if message differs' do
        new_event = service.events.where(key: attributes[:key]).first

        service.should have(1).event
        service.should_not have(2).events
        new_event.should eq event
      end

      # pending
      # end
    end
  end
end

#   describe 'PUT /integration' do
#     let!(:event) { create(:event) }
#     before { get :show, service_id: service.id, id: event.id }

#     it { should respond_with(:ok) }
#     it { should render_template(:show) }
#   end
# end
