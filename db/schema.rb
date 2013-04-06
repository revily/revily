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

ActiveRecord::Schema.define(:version => 20130406201859) do

  create_table "accounts", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.string   "address"
    t.string   "uuid",             :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "contacts", ["contactable_id"], :name => "index_contacts_on_contactable_id"

  create_table "escalation_policies", :force => true do |t|
    t.string   "name"
    t.string   "uuid",                  :null => false
    t.integer  "escalation_loop_limit"
    t.integer  "account_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "escalation_policies", ["account_id"], :name => "index_escalation_policies_on_account_id"

  create_table "escalation_rules", :force => true do |t|
    t.integer  "escalation_timeout",   :default => 30
    t.integer  "position"
    t.string   "uuid",                                 :null => false
    t.integer  "assignable_id"
    t.string   "assignable_type"
    t.integer  "escalation_policy_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "escalation_rules", ["assignable_id"], :name => "index_escalation_rules_on_assignable_id"
  add_index "escalation_rules", ["escalation_policy_id"], :name => "index_escalation_rules_on_escalation_policy_id"

  create_table "hound_actions", :force => true do |t|
    t.string   "action",          :null => false
    t.string   "actionable_type", :null => false
    t.integer  "actionable_id",   :null => false
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.text     "changeset"
  end

  add_index "hound_actions", ["actionable_type", "actionable_id"], :name => "index_hound_actions_on_actionable_type_and_actionable_id"
  add_index "hound_actions", ["user_type", "user_id"], :name => "index_hound_actions_on_user_type_and_user_id"

  create_table "incidents", :force => true do |t|
    t.text     "message"
    t.text     "description"
    t.text     "details"
    t.string   "state"
    t.string   "key"
    t.integer  "current_user_id"
    t.integer  "current_escalation_rule_id"
    t.integer  "escalation_loop_count",      :default => 0
    t.string   "uuid",                                      :null => false
    t.integer  "service_id"
    t.datetime "triggered_at"
    t.datetime "acknowledged_at"
    t.datetime "resolved_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "incidents", ["current_user_id"], :name => "index_events_on_current_user_id"
  add_index "incidents", ["uuid"], :name => "index_events_on_uuid", :unique => true

  create_table "notification_rules", :force => true do |t|
    t.integer  "start_delay", :default => 0
    t.string   "uuid"
    t.integer  "contact_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "notification_rules", ["contact_id"], :name => "index_notification_rules_on_contact_id"

  create_table "schedule_layers", :force => true do |t|
    t.integer  "duration"
    t.string   "rule",        :default => "daily", :null => false
    t.integer  "count",       :default => 1,       :null => false
    t.integer  "position"
    t.string   "uuid"
    t.integer  "schedule_id"
    t.datetime "start_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "schedule_layers", ["schedule_id"], :name => "index_schedule_layers_on_schedule_id"

  create_table "schedules", :force => true do |t|
    t.string   "name"
    t.string   "time_zone",  :default => "UTC"
    t.string   "uuid"
    t.integer  "account_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "schedules", ["account_id"], :name => "index_schedules_on_account_id"

  create_table "service_escalation_policies", :force => true do |t|
    t.string   "uuid",                 :null => false
    t.integer  "service_id"
    t.integer  "escalation_policy_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "service_escalation_policies", ["escalation_policy_id"], :name => "index_service_escalation_policies_on_escalation_policy_id"
  add_index "service_escalation_policies", ["service_id"], :name => "index_service_escalation_policies_on_service_id"

  create_table "services", :force => true do |t|
    t.string   "name"
    t.integer  "auto_resolve_timeout"
    t.integer  "acknowledge_timeout"
    t.string   "state"
    t.string   "uuid"
    t.string   "authentication_token"
    t.integer  "account_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "services", ["account_id"], :name => "index_services_on_account_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_schedule_layers", :force => true do |t|
    t.string   "uuid",              :null => false
    t.integer  "position",          :null => false
    t.integer  "schedule_layer_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "user_schedule_layers", ["schedule_layer_id"], :name => "index_user_schedule_layers_on_schedule_layer_id"
  add_index "user_schedule_layers", ["user_id"], :name => "index_user_schedule_layers_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                   :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "uuid",                                   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.integer  "account_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id", :unique => true
  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["uuid"], :name => "index_users_on_uuid", :unique => true

end
