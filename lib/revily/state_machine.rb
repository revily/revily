require "active_support/string_inquirer"

module Revily
  class StateMachine
    attr_reader :object, :initial_state, :previous_state, :current_state

    def initialize(object)
      @object = object
    end

    def state_attribute
      :state
    end

    def initial_state
      "triggered"
    end

    # def initialize_state
    # object.send(state_attribute, initial_state) unless object.send(state_attribute).present?
    # end

    def state
      @state ||= string_inquirer(object.send("#{state_getter}") || initial_state)
    end

    def state=(state)
      @previous_state = @state
      @state = string_inquirer(object.send("#{state_setter}", state.to_s))
    end

    def save
      if object.save
        object
      else
        false
      end
    end

    def set_state(state)
      state = state.to_s
      if object.save
        true
      else
        false
      end
    end

    def trigger

    end

    def escalate
      set_state :triggered if can_escalate?

      state = "triggered"
      if object.save
        object
      else
        false
      end
    end

    def acknowledge
      return false unless can_acknowledge?

      state = "acknowledged"

      save
    end

    def resolve
      return false unless can_resolve?

      set_state = "resolved"
    end


    def transition(action)

    end

    def can_trigger?
      acknowledged?
    end

    def can_escalate?
      triggered? || acknowledged?
    end

    def can_acknowledge?
      triggered?
    end

    def can_resolve?
      triggered? || acknowledged?
    end

    def triggered?
      state.triggered?
    end

    def acknowledged?
      state.acknowledged?
    end

    def resolved?
      state.resolved?
    end

    private

    def state_getter
      "#{state_attribute}"
    end

    def state_setter
      "#{state_attribute}="
    end

    def set_previous_state
      @previous_state = @state
    end

    def string_inquirer(string)
      ActiveSupport::StringInquirer.new(string)
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s =~ /(.+)!/
        self.transition($1, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.end_with?('!') || super
    end
  end
end
