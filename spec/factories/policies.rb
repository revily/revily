# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :policy do
    name { Forgery(:name).job_title.pluralize }
    loop_limit 3
    account

    trait :with_rules do
      after(:create) do |policy|
        create(:policy_rule, :for_schedule, policy: policy)
      end
    end

    trait :for_dan_ryan do
      after(:create) do |policy|
        create(:rule, :for_dan_ryan, policy: policy)
      end
    end
  end
end
