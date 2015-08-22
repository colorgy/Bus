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

ActiveRecord::Schema.define(version: 20150822143154) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: :cascade do |t|
    t.string   "username",               default: "", null: false
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  add_index "admin_users", ["username"], name: "index_admin_users_on_username", unique: true

  create_table "bills", force: :cascade do |t|
    t.integer  "price",                       null: false
    t.integer  "amount",                      null: false
    t.integer  "invoice_id"
    t.string   "invoice_type",                null: false
    t.text     "invoice_data"
    t.text     "data"
    t.string   "state",                       null: false
    t.string   "payment_code"
    t.datetime "paid_at"
    t.integer  "used_credits",    default: 0, null: false
    t.datetime "deadline"
    t.integer  "user_id",                     null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "deleted_at"
    t.string   "uuid",                        null: false
    t.string   "type",                        null: false
    t.string   "virtual_account"
  end

  add_index "bills", ["deleted_at"], name: "index_bills_on_deleted_at"

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "price"
    t.integer  "schedule_id"
    t.integer  "bill_id"
    t.integer  "vehicle_id"
    t.string   "seat_no"
    t.string   "state",                    null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "deleted_at"
    t.string   "receiver_name",            null: false
    t.string   "receiver_email"
    t.string   "receiver_phone"
    t.string   "receiver_identity_number", null: false
  end

  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at"
  add_index "orders", ["schedule_id", "bill_id", "vehicle_id", "seat_no"], name: "order_uniq_id", unique: true

  create_table "route_requests", force: :cascade do |t|
    t.string   "name",                null: false
    t.string   "email",               null: false
    t.string   "phone_number"
    t.integer  "user_id",             null: false
    t.integer  "route_id"
    t.string   "request_origin"
    t.string   "request_destination"
    t.text     "message"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "departure_time"
  end

  create_table "routes", force: :cascade do |t|
    t.string   "origin"
    t.string   "destination"
    t.string   "direction"
    t.integer  "price"
    t.text     "description"
    t.text     "announcement"
    t.string   "route_map_url"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "parent_id"
    t.boolean  "is_available",  default: false
    t.boolean  "hidden",        default: true
    t.boolean  "fake_full",     default: false
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "departure_time", null: false
    t.integer  "route_id"
    t.string   "contact"
    t.integer  "vehicle_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "seats", force: :cascade do |t|
    t.integer  "vehicle_id"
    t.integer  "priority"
    t.string   "row_no"
    t.string   "seat_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

  create_table "user_cart_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "route_id"
    t.integer  "schedule_id"
    t.integer  "seat_id"
    t.integer  "price"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "quantity",    default: 1, null: false
  end

  add_index "user_cart_items", ["user_id", "seat_id", "schedule_id"], name: "index_user_cart_items_on_user_id_and_seat_id_and_schedule_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.string   "name"
    t.string   "avatar_url"
    t.string   "cover_photo_url"
    t.string   "gender"
    t.string   "fbid"
    t.string   "uid"
    t.string   "identity"
    t.string   "organization_code"
    t.string   "department_code"
    t.string   "invoice_subsume_token"
    t.datetime "invoice_subsume_token_created_at"
    t.integer  "cart_items_count",                 default: 0
    t.datetime "refreshed_at"
    t.string   "core_access_token"
    t.string   "core_refresh_token"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vehicles", force: :cascade do |t|
    t.string   "name"
    t.string   "registration_number"
    t.integer  "capacity"
    t.text     "description"
    t.text     "seat_info"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                     null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 1073741823
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
