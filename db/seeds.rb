# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

include FactoryGirl::Syntax::Methods

puts "create account"
account = Account.first_or_create(
  subdomain: "acme"
)

puts "create user"
user = account.users.first_or_create(
  name: "Dan Ryan",
  email: "dan@example.com",
  password: "asdfasdf",
  password_confirmation: "asdfasdf",
)

%w[ Application Nagios Pingdom ].each do |name|
  puts "create service #{name}"
  account.services.first_or_create(
    name: name,
    auto_resolve_timeout: 240,
    acknowledge_timeout: 30
  )
end

puts "create policy"
policy = account.policies.first_or_create(
  name: "Operations",
  loop_limit: 3
)

puts "create rule"
policy.policy_rules.first_or_create(
  assignment: user,
  escalation_timeout: 1
)