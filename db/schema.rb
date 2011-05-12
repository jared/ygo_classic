# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 12) do

  create_table "cars", :force => true do |t|
    t.string  "make",                          :null => false
    t.string  "model",                         :null => false
    t.string  "color",                         :null => false
    t.string  "license_plate"
    t.string  "registration_state"
    t.string  "vehicle_identification_number"
    t.integer "year"
    t.integer "user_id"
    t.text    "notes"
    t.boolean "private"
  end

  add_index "cars", ["user_id"], :name => "index_cars_on_user_id"

  create_table "line_items", :force => true do |t|
    t.integer "work_order_id"
    t.string  "description"
  end

  add_index "line_items", ["work_order_id"], :name => "index_line_items_on_work_order_id"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "open_id_authentication_settings", :force => true do |t|
    t.string "setting"
    t.binary "value"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "remember_token"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "receive_email"
    t.string   "identity_url"
    t.string   "display_name"
  end

  create_table "work_orders", :force => true do |t|
    t.integer "car_id"
    t.integer "mileage"
    t.string  "shop"
    t.decimal "total_cost"
    t.date    "date"
    t.text    "notes"
  end

  add_index "work_orders", ["shop"], :name => "index_work_orders_on_shop"
  add_index "work_orders", ["car_id"], :name => "index_work_orders_on_car_id"

end
