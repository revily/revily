# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    service
    # message "Shit just got real."
    message { Forgery(:lorem_ipsum).words(5) }

    factory :acknowledged_event do
      state "acknowledged"
    end

    factory :resolved_event do
      state "resolved"
    end

    factory :event_with_key do
      key "app1.example.com/load_average"
    end
  end
end
