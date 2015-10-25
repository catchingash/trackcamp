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

ActiveRecord::Schema.define(version: 20151025175551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "started_at",       limit: 8, null: false
    t.integer  "ended_at",         limit: 8, null: false
    t.integer  "activity_type_id",           null: false
    t.integer  "user_id",                    null: false
    t.string   "data_source"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "activities", ["activity_type_id"], name: "index_activities_on_activity_type_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "activity_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "google_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "activity_types", ["google_id"], name: "index_activity_types_on_google_id", unique: true, using: :btree

  create_table "event_types", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "time",          limit: 8, null: false
    t.float    "rating"
    t.text     "note"
    t.integer  "event_type_id",           null: false
    t.integer  "user_id",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "sleep", force: :cascade do |t|
    t.integer  "started_at", limit: 8, null: false
    t.integer  "ended_at",   limit: 8, null: false
    t.float    "rating"
    t.integer  "user_id",              null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "sleep", ["user_id"], name: "index_sleep_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "uid",                                                  null: false
    t.string   "email",                                                null: false
    t.string   "refresh_token"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "time_zone",     default: "Pacific Time (US & Canada)", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  add_foreign_key "activities", "activity_types"
  add_foreign_key "activities", "users"
  add_foreign_key "event_types", "users"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "users"
  add_foreign_key "sleep", "users"
end
