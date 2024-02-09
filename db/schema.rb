# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_09_125308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "device_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "number_of_buttons"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name", null: false
    t.string "dev_eui", null: false
    t.string "app_eui"
    t.string "app_key"
    t.string "hw_version"
    t.string "fw_version"
    t.integer "battery"
    t.datetime "last_time_seen", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "device_type_id"
    t.bigint "user_id"
    t.index ["device_type_id"], name: "index_devices_on_device_type_id"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "title"
    t.string "text"
    t.string "data"
    t.boolean "acknowledged", default: false
    t.string "acknowledged_by"
    t.datetime "acknowledged_at", precision: nil
    t.bigint "device_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["device_id"], name: "index_orders_on_device_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "devices", "device_types"
  add_foreign_key "devices", "users"
  add_foreign_key "orders", "devices"
  add_foreign_key "orders", "users"
end
