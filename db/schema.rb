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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130713060607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: true do |t|
    t.string   "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: true do |t|
    t.string   "label"
    t.string   "type"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.string   "address"
    t.string   "uuid",             null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "contacts", ["contactable_id"], name: "index_contacts_on_contactable_id", using: :btree

  create_table "events", force: true do |t|
    t.integer "source_id"
    t.string  "source_type"
    t.text    "data",        default: "{}"
    t.integer "account_id"
    t.string  "event"
  end

  add_index "events", ["account_id"], name: "index_events_on_account_id", using: :btree
  add_index "events", ["source_id", "source_type"], name: "index_events_on_source_id_and_source_type", using: :btree

  create_table "incidents", force: true do |t|
    t.text     "message"
    t.text     "description"
    t.text     "details"
    t.string   "state"
    t.string   "key"
    t.integer  "current_user_id"
    t.integer  "current_policy_rule_id"
    t.integer  "escalation_loop_count",  default: 0
    t.string   "uuid",                               null: false
    t.integer  "service_id"
    t.datetime "triggered_at"
    t.datetime "acknowledged_at"
    t.datetime "resolved_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "incidents", ["current_user_id"], name: "index_incidents_on_current_user_id", using: :btree
  add_index "incidents", ["uuid"], name: "index_incidents_on_uuid", unique: true, using: :btree

  create_table "notification_rules", force: true do |t|
    t.integer  "start_delay", default: 0
    t.string   "uuid"
    t.integer  "contact_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "notification_rules", ["contact_id"], name: "index_notification_rules_on_contact_id", using: :btree

  create_table "policies", force: true do |t|
    t.string   "name"
    t.string   "uuid",       null: false
    t.integer  "loop_limit"
    t.integer  "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "policies", ["account_id"], name: "index_policies_on_account_id", using: :btree

  create_table "policy_rules", force: true do |t|
    t.integer  "escalation_timeout", default: 30
    t.integer  "position"
    t.string   "uuid",                            null: false
    t.integer  "assignment_id"
    t.string   "assignment_type"
    t.integer  "policy_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "policy_rules", ["assignment_id", "assignment_type"], name: "index_policy_rules_on_assignment_id_and_assignment_type", using: :btree
  add_index "policy_rules", ["policy_id"], name: "index_policy_rules_on_policy_id", using: :btree

  create_table "schedule_layers", force: true do |t|
    t.integer  "duration"
    t.string   "rule",        default: "daily", null: false
    t.integer  "count",       default: 1,       null: false
    t.integer  "position"
    t.string   "uuid"
    t.integer  "schedule_id"
    t.datetime "start_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "schedule_layers", ["schedule_id"], name: "index_schedule_layers_on_schedule_id", using: :btree

  create_table "schedules", force: true do |t|
    t.string   "name"
    t.string   "time_zone",  default: "UTC"
    t.string   "uuid"
    t.integer  "account_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "schedules", ["account_id"], name: "index_schedules_on_account_id", using: :btree

  create_table "service_policies", force: true do |t|
    t.string   "uuid",       null: false
    t.integer  "service_id"
    t.integer  "policy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "service_policies", ["policy_id"], name: "index_service_policies_on_policy_id", using: :btree
  add_index "service_policies", ["service_id"], name: "index_service_policies_on_service_id", using: :btree

  create_table "services", force: true do |t|
    t.string   "name"
    t.integer  "auto_resolve_timeout"
    t.integer  "acknowledge_timeout"
    t.string   "state"
    t.string   "uuid"
    t.string   "authentication_token"
    t.integer  "account_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "services", ["account_id"], name: "index_services_on_account_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "user_schedule_layers", force: true do |t|
    t.string   "uuid",              null: false
    t.integer  "position",          null: false
    t.integer  "schedule_layer_id"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "user_schedule_layers", ["schedule_layer_id"], name: "index_user_schedule_layers_on_schedule_layer_id", using: :btree
  add_index "user_schedule_layers", ["user_id"], name: "index_user_schedule_layers_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "uuid",                                null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.integer  "account_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree

end
