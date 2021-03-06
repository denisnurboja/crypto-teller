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

ActiveRecord::Schema.define(version: 20140402194834) do

  create_table "accounts", force: true do |t|
    t.decimal  "balance",      default: 0.0
    t.decimal  "held_balance", default: 0.0
    t.integer  "user_id"
    t.integer  "lock_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", force: true do |t|
    t.string   "address"
    t.string   "label"
    t.string   "currency"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "direction"
    t.decimal  "amount"
    t.string   "status",         default: "pending"
    t.string   "note"
    t.string   "address"
    t.string   "currency"
    t.string   "transaction_id"
    t.integer  "account_id"
    t.integer  "lock_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["transaction_id"], name: "index_orders_on_transaction_id", unique: true

  create_table "transfers", force: true do |t|
    t.string   "direction"
    t.decimal  "amount"
    t.string   "status",       default: "pending"
    t.string   "note"
    t.integer  "account_id"
    t.integer  "lock_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                  null: false
    t.string   "encrypted_password",                     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
