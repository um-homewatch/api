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

ActiveRecord::Schema.define(version: 20170421100250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "homes", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "location",   null: false
    t.string   "tunnel",     null: false
    t.inet     "ip_address", null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_homes_on_ip_address", unique: true, using: :btree
    t.index ["user_id"], name: "index_homes_on_user_id", using: :btree
  end

  create_table "scenario_things", force: :cascade do |t|
    t.integer  "thing_id"
    t.integer  "scenario_id"
    t.json     "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["scenario_id"], name: "index_scenario_things_on_scenario_id", using: :btree
    t.index ["thing_id"], name: "index_scenario_things_on_thing_id", using: :btree
  end

  create_table "scenarios", force: :cascade do |t|
    t.string   "name"
    t.integer  "home_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["home_id"], name: "index_scenarios_on_home_id", using: :btree
  end

  create_table "things", force: :cascade do |t|
    t.string   "type"
    t.string   "subtype"
    t.json     "connection_info"
    t.integer  "home_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["home_id"], name: "index_things_on_home_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
