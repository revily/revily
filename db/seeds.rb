# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

include FactoryGirl::Syntax::Methods

account = create(:account, subdomain: "acme")

user = create(:user,
  name: "Dan Ryan",
  email: "dan@example.com",
  password: "asdfasdf",
  password_confirmation: "asdfasdf"
)

