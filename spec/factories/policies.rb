# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :policy do
    name { Forgery(:name).job_title.pluralize }
    loop_limit 3
    account

    # ignored do
      # uuid
    # end

    # after(:stub) do |policy|
      # policy.ensure_uuid
    # end

    trait :with_rules do
      after(:create) do |policy|
        user = create(:user, account: policy.account)
        create(:policy_rule, :for_schedule, policy: policy, assignment_attributes: { id: user.uuid, type: "User" })
      end
    end

    trait :for_dan_ryan do
      after(:create) do |policy|
        create(:rule, :for_dan_ryan, policy: policy)
      end
    end
  end
end
