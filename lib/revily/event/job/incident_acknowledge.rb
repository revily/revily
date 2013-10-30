module Revily
  module Event
    class Job
      class IncidentAcknowledge < Incident

        def process
          # sms/voice controllers now handle this.
          # current_user.contacts.each do |contact|
          #   contact.notify(:acknowledged, incidents)
          # end
        end

      end
    end
  end
end
