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

ActiveRecord::Schema.define(version: 20140502220334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: true do |t|
    t.string   "name"
    t.integer  "health"
    t.integer  "battery"
    t.integer  "facing"
    t.string   "planet"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.integer  "inventory_id"
    t.integer  "tile_id"
  end

  add_index "characters", ["inventory_id"], name: "index_characters_on_inventory_id", using: :btree
  add_index "characters", ["item_id"], name: "index_characters_on_item_id", using: :btree
  add_index "characters", ["tile_id"], name: "index_characters_on_tile_id", using: :btree

  create_table "inventories", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.boolean  "pickupable"
    t.boolean  "walkoverable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_id"
    t.string   "item_type"
    t.string   "affects"
    t.integer  "moves_player_x"
    t.integer  "moves_player_y"
    t.boolean  "consumable"
    t.integer  "battery_effect"
    t.integer  "health_effect"
    t.string   "default_message"
  end

  add_index "items", ["inventory_id"], name: "index_items_on_inventory_id", using: :btree

  create_table "tiles", force: true do |t|
    t.integer  "tile_id"
    t.integer  "x"
    t.integer  "y"
    t.string   "x_y_pair"
    t.integer  "tile_type"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  add_index "tiles", ["item_id"], name: "index_tiles_on_item_id", using: :btree

  create_table "users", force: true do |t|
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
    t.boolean  "logged_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "users", ["character_id"], name: "index_users_on_character_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["logged_in"], name: "index_users_on_logged_in", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
