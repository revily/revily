require "spec_helper"

describe ScheduleLayer do
  extend ScheduleMixins::Macros
  include ScheduleMixins::Helpers

  pause_events!
  freeze_time!

  specify "associations" do
    expect(subject).to belong_to(:schedule)
    expect(subject).to have_many(:user_schedule_layers)
    expect(subject).to have_many(:users).through(:user_schedule_layers)
  end

  specify "validations" do
    expect(subject).to ensure_inclusion_of(:rule).in_array(%w[ hourly daily weekly monthly yearly ])
    expect(subject).to validate_presence_of(:count)
    expect(subject).to validate_presence_of(:rule)
  end

  specify "callbacks" do
    schedule_layer = build(:schedule_layer)
    allow(schedule_layer).to receive(:calculate_duration_in_seconds)
    allow(schedule_layer).to receive(:reset_start_at_to_beginning_of_day)

    schedule_layer.save

    expect(schedule_layer).to have_received(:calculate_duration_in_seconds)
    expect(schedule_layer).to have_received(:reset_start_at_to_beginning_of_day)
  end

  context "attributes" do
    it "uses uuid for #to_param" do
      obj = stub_model(subject.class).as_new_record
      expect(obj.to_param).to eq obj.uuid
    end
  end

  context "duration calculations" do
    let(:hourly) { create(:schedule_layer, :hourly) }
    let(:daily) { create(:schedule_layer, :daily) }
    let(:weekly) { create(:schedule_layer, :weekly) }
    let(:monthly) { create(:schedule_layer, :monthly) }
    let(:yearly) { create(:schedule_layer, :yearly) }

    it "calculates the correct rotation length in seconds" do
      expect(hourly.duration).to be 28800
      expect(hourly.unit_duration).to eq 3600

      expect(daily.duration).to be 86400
      expect(daily.unit_duration).to eq 86400

      expect(weekly.duration).to be 604800
      expect(weekly.unit_duration).to eq 604800

      expect(monthly.duration).to be 2592000
      expect(monthly.unit_duration).to eq 2592000

      expect(yearly.duration).to be 31557600
      expect(yearly.unit_duration).to eq 31557600
    end
  end

  describe "#reset_start_at_to_beginning_of_day" do
    let(:schedule_layer) { build(:schedule_layer, start_at: now) }

    it "resets start_at to beginning of day" do
      schedule_layer.save
      expect(schedule_layer.start_at).to eq now.beginning_of_day
    end
  end

  describe "#user_offset" do
    let(:user_1) { double("User", id: 1, position: 1) }
    let(:user_2) { double("User", id: 2, position: 2) }

    before do
      allow_any_instance_of(ScheduleLayer).to receive(:user_positions).and_return({ 1 => 1, 2 => 2 })
    end

    it "hourly" do
      schedule_layer = create(:schedule_layer, :hourly)

      expect(schedule_layer.user_offset(user_1)).to eq 0
      expect(schedule_layer.user_offset(user_2)).to eq 28800
    end
    it "daily" do
      schedule_layer = create(:schedule_layer, :daily)

      expect(schedule_layer.user_offset(user_1)).to eq 0
      expect(schedule_layer.user_offset(user_2)).to eq 86400
    end

    it "weekly" do
      schedule_layer = create(:schedule_layer, :weekly)

      expect(schedule_layer.user_offset(user_1)).to eq 0
      expect(schedule_layer.user_offset(user_2)).to eq 604800
    end
  end

end
