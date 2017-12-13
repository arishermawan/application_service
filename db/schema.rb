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

ActiveRecord::Schema.define(version: 20171213141235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.decimal "gopay", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "location"
    t.integer "service"
    t.decimal "gopay", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "orders", force: :cascade do |t|
    t.string "pickup"
    t.string "destination"
    t.integer "payment"
    t.decimal "distance"
    t.decimal "total"
    t.bigint "customer_id"
    t.bigint "driver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "service"
    t.string "status"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["driver_id"], name: "index_orders_on_driver_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.decimal "gopay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "drivers"
end
