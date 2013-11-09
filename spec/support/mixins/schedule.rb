module ScheduleMixins
  module Macros
    def create_schedule(options={})
      let!(:account) { create(:account) }
      options[:users_count] ||= 1

      let(:users) { create_list(:user, options[:users_count], account: account) }
      let(:schedule) { create(:schedule, :with_layers, options.merge(account: account)) }
      let(:schedule_layer) { schedule.schedule_layers.first }

      before do
        schedule_layer.users = users
        schedule_layer.save
      end

      (1..options[:users_count]).each_with_index do |id, index|
        let("user_#{id}") { schedule_layer.users[index] }
      end
    end

    def now
      Time.zone.local(2013, 10, 26, 10, 49)
    end

    def freeze_time!
      before { Timecop.freeze(now.beginning_of_day) }
      after { Timecop.return }
    end
  end

  module Helpers
    def now
      Time.zone.local(2013, 10, 26, 10, 49)
    end

    def advance_time_by(time = 1.day)
      Timecop.travel time.from_now
    end

    def freeze_time!
      Timecop.freeze(now.beginning_of_day)
      yield
    ensure
      Timecop.return
    end
  end
end


# module ScheduleMixins
#   module Macros

#     def mock_schedule(options={})
#       layers_count = options[:layers_count] || 1
#       users_count = options[:users_count] || 1
#       count = options[:count] || 1
#       rule = options[:rule] || "daily"

#       let(:account) { build_stubbed(:account) }
#       let(:schedule) { build_stubbed(:schedule, account: account) }

#       (1..layers_count).each do |layer_position|
#         layer = build_stubbed(:schedule_layer, layers_count,
#                               schedule: schedule,
#                               position: layer_position,
#                               rule: rule,
#                               count: count,
#                               account: account)
#         let("layer_#{layer_position}") { layer }

#         users = build_stubbed_list(:user, users_count, account: account)

#         users.each_with_index do |user, user_position|
#           let("user_#{layer_position}_#{user_position + 1}") { user }
#         end

#         before do
#           allow(layer).to receive(:users).and_return(users)
#         end
#       end

#       before do
#         allow(schedule).to receive(:schedule_layers).and_return([])
#       end
#     end

#     def create_schedule(options={})
#       let!(:account) { create(:account) }
#       options[:users_count] ||= 1

#       let(:users) { create_list(:user, options[:users_count], account: account) }
#       let(:schedule) { create(:schedule, :with_layers, options.merge(account: account)) }
#       let(:schedule_layer) { schedule.schedule_layers.first }

#       before do
#         schedule_layer.users = users
#         schedule_layer.save
#       end

#       (1..options[:users_count]).each_with_index do |id, index|
#         let("user_#{id}") { schedule_layer.users[index] }
#       end
#     end


#     def now
#       Time.zone.local(2013, 10, 26, 10, 49)
#     end

#     def freeze_time!
#       before { Timecop.freeze(now.beginning_of_day) }
#       after { Timecop.return }
#     end
#   end

#   module Helpers

#     def now
#       Time.zone.local(2013, 10, 26, 10, 49)
#     end

#     def freeze_time!
#       Timecop.freeze(now.beginning_of_day)
#       yield
#     ensure
#       Timecop.return
#     end

#   end
# end
