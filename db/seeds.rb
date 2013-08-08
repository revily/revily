include FactoryGirl::Syntax::Methods

puts "create account"
account = Account.first_or_create(
  subdomain: "acme"
)

ActsAsTenant.current_tenant = account

puts "create user"
user = account.users.where(
  name: "Dan Ryan",
  email: "dan@example.com",
  authentication_token: "dGpYyvbApYxXGAvPkQjt"
).first_or_create(password: "asdfasdf", password_confirmation: "asdfasdf")

services = []
%w[ Application Nagios Pingdom ].each do |name|
  puts "create service #{name}"
  services << Service.where(
    name: name,
    auto_resolve_timeout: 240,
    acknowledge_timeout: 30
  ).first_or_create
end

puts "create policy"
policy = Policy.first_or_create(
  name: "Operations",
  loop_limit: 3
)

puts "create rule"
policy.policy_rules.first_or_create(
  assignment: user,
  escalation_timeout: 1
)

puts "create incidents"
services.each do |service|
  next if service.incidents.count >= 3
  create(:incident, service: service)
  create(:incident, :acknowledged, service: service)
  create(:incident, :resolved, service: service)
end

puts "create hooks"
Hook.where(attributes_for(:hook, :test, :for_incidents)).first_or_create
Hook.where(attributes_for(:hook, :log, :all_events)).first_or_create
