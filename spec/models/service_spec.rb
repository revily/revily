require 'spec_helper'

describe Service do
  pause_events!

  context 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:incidents) }
    it { should have_one(:service_policy) }
    it { should have_one(:policy).through(:service_policy) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:auto_resolve_timeout) }
    it { should validate_presence_of(:acknowledge_timeout) }
    it { should validate_presence_of(:state) }
  end

  context 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
  end

  context 'incidents' do
    describe '#incident_counts' do
      let(:service) { create(:service) }
      let(:incidents) { create_list(:incident, 5, service: service) }

      before do
        Incident.any_instance.stub(assign: true)
        incidents.first.acknowledge
        incidents.last.resolve
      end

      it 'returns incident counts' do
        expect(service.incident_counts.triggered).to eq 3
        expect(service.incident_counts.acknowledged).to eq 1
        expect(service.incident_counts.resolved).to eq 1
      end

      it 'refreshes cached counts' do
        incidents.first.resolve
        expect(service.incident_counts.resolved).to eq 2
      end
    end
  end

  describe '#health' do
    let(:service) { create(:service) }

    before do
      Incident.any_instance.stub(assign: true)
      service.incidents.destroy_all
      service.reload
    end

    it 'health is "ok" with no open incidents' do
      expect(service.health).to eq "ok"
    end

    it 'health is "critical" with triggered incidents' do
      service.incidents << create(:incident, service: service)
      
      expect(service.health).to eq "critical"
    end


    it 'health is "warning" with acknowledged incidents and no triggered incidents' do
      service.incidents << create(:incident, service: service)
      service.incidents.first.acknowledge
      service.reload

      expect(service.health).to eq "warning"
    end

  end
end
