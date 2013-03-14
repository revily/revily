# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130313073039) do

  create_table "alerts", :force => true do |t|
    t.string   "type"
    t.datetime "sent_at"
    t.string   "uuid",       :default => "", :null => false
    t.integer  "event_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "alerts", ["event_id"], :name => "index_alerts_on_event_id"
  add_index "alerts", ["uuid"], :name => "index_alerts_on_uuid", :unique => true

  create_table "contacts", :force => true do |t|
    t.string   "label"
    t.string   "type"
    t.string   "address"
    t.string   "uuid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "escalation_policies", :force => true do |t|
    t.string   "name"
    t.string   "uuid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "escalation_rules", :force => true do |t|
    t.integer  "escalation_timeout"
    t.string   "uuid"
    t.integer  "assignable_id"
    t.string   "assignable_type"
    t.integer  "escalation_policy_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "escalation_rules", ["assignable_id"], :name => "index_escalation_rules_on_assignable_id"
  add_index "escalation_rules", ["escalation_policy_id"], :name => "index_escalation_rules_on_escalation_policy_id"

  create_table "events", :force => true do |t|
    t.text     "message"
    t.text     "details"
    t.string   "state"
    t.string   "uuid",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "events", ["uuid"], :name => "index_events_on_uuid", :unique => true

  create_table "notification_rules", :force => true do |t|
    t.integer  "start_delay"
    t.string   "uuid"
    t.integer  "contact_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "notification_rules", ["contact_id"], :name => "index_notification_rules_on_contact_id"

  create_table "schedules", :force => true do |t|
    t.string   "name"
    t.string   "timezone"
    t.string   "rotation_type"
    t.integer  "shift_length"
    t.string   "shift_length_unit"
    t.string   "uuid"
    t.datetime "start_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "services", :force => true do |t|
    t.string   "name"
    t.integer  "auto_resolve_timeout"
    t.integer  "acknowledgement_timeout"
    t.string   "state"
    t.string   "uuid"
    t.string   "authentication_token"
    t.integer  "escalation_policy_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "services", ["escalation_policy_id"], :name => "index_services_on_escalation_policy_id"

  create_table "user_schedules", :force => true do |t|
    t.string   "uuid"
    t.integer  "schedule_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_schedules", ["schedule_id"], :name => "index_user_schedules_on_schedule_id"
  add_index "user_schedules", ["user_id"], :name => "index_user_schedules_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "uuid",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["uuid"], :name => "index_users_on_uuid", :unique => true

end
