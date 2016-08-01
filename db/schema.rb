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

ActiveRecord::Schema.define(version: 20160731080552) do

  create_table "positions", force: :cascade do |t|
    t.string   "name"
    t.integer  "layer"
    t.integer  "min_pv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "positions", ["name"], name: "index_positions_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "member_code"
    t.string   "password_digest"
    t.string   "f_name"
    t.string   "l_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "email"
    t.string   "phone"
    t.string   "line"
    t.string   "role"
    t.integer  "position_id"
    t.string   "remember_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "iden_num"
  end

  add_index "users", ["iden_num"], name: "index_users_on_iden_num", unique: true
  add_index "users", ["member_code"], name: "index_users_on_member_code", unique: true
  add_index "users", ["position_id"], name: "index_users_on_position_id"

end
