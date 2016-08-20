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

ActiveRecord::Schema.define(version: 20160819194635) do

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "avito_code"
    t.float    "yield"
  end

  add_index "districts", ["city_id"], name: "index_districts_on_city_id"

  create_table "rentals", force: :cascade do |t|
    t.integer  "city_id"
    t.integer  "district_id"
    t.integer  "type_id"
    t.integer  "price"
    t.integer  "surface"
    t.integer  "sqm_price"
    t.integer  "rooms"
    t.integer  "bathrooms"
    t.string   "website"
    t.string   "link"
    t.string   "last_update"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "detail"
    t.string   "temp"
  end

  add_index "rentals", ["city_id"], name: "index_rentals_on_city_id"
  add_index "rentals", ["district_id"], name: "index_rentals_on_district_id"
  add_index "rentals", ["type_id"], name: "index_rentals_on_type_id"

  create_table "sales", force: :cascade do |t|
    t.integer  "city_id"
    t.integer  "district_id"
    t.integer  "type_id"
    t.integer  "price"
    t.integer  "surface"
    t.integer  "rooms"
    t.integer  "bathrooms"
    t.string   "website"
    t.string   "link"
    t.string   "last_update"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "sqm_price"
    t.text     "detail"
    t.string   "temp"
  end

  add_index "sales", ["city_id"], name: "index_sales_on_city_id"
  add_index "sales", ["district_id"], name: "index_sales_on_district_id"
  add_index "sales", ["type_id"], name: "index_sales_on_type_id"

  create_table "scraps", force: :cascade do |t|
    t.string   "website"
    t.string   "category"
    t.integer  "city_id"
    t.time     "started"
    t.time     "ended"
    t.integer  "total_scraped"
    t.float    "variation"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "scraps", ["city_id"], name: "index_scraps_on_city_id"

  create_table "types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
