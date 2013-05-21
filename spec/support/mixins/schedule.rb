# module ScheduleMixins
#   module Macros
#     def create_schedule(options={})
#       options[:users_count] ||= 1
#       let(:schedule) { create(:schedule_with_layers_and_users, options) }
#       let(:schedule_layer) { schedule.schedule_layers.first }

#       (1..options[:users_count]).each_with_index do |id, index|
#         let("user_#{id}") { schedule_layer.users[index] }
#       end
#     end
#   end

#   module Helpers
#     def now
#       Time.zone.now
#     end
#   end
# end

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
      end

      (1..options[:users_count]).each_with_index do |id, index|
        let("user_#{id}") { schedule_layer.users[index] }
      end
    end
  end

  module Helpers
    def now
      Time.zone.now
    end
  end
end