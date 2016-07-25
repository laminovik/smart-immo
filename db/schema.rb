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

ActiveRecord::Schema.define(version: 20160725151745) do

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
  end

  add_index "sales", ["city_id"], name: "index_sales_on_city_id"
  add_index "sales", ["district_id"], name: "index_sales_on_district_id"
  add_index "sales", ["type_id"], name: "index_sales_on_type_id"

  create_table "types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
