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

ActiveRecord::Schema.define(version: 20180206145926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appliances", force: :cascade do |t|
    t.string "name", null: false
    t.string "appliance_type"
    t.integer "home_id", null: false
  end

  create_table "homes", force: :cascade do |t|
    t.string "name", null: false
    t.string "apartment"
    t.string "city"
    t.string "street"
    t.string "zip_code"
    t.string "country_code"
    t.integer "user_id", null: false
  end

  create_table "outlets", force: :cascade do |t|
    t.string "name", null: false
    t.string "device_id", null: false
    t.integer "home_id", null: false
    t.integer "appliance_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "password_hash", null: false
    t.string "email", null: false
    t.string "token"
  end

end
