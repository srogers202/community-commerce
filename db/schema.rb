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

ActiveRecord::Schema.define(version: 20150306172101) do

  create_table "product_expirations", force: :cascade do |t|
    t.integer  "shop"
    t.integer  "product"
    t.datetime "expiration"
    t.boolean  "complete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_targets", force: :cascade do |t|
    t.integer  "shop"
    t.integer  "product"
    t.integer  "minqty"
    t.decimal  "price",             precision: 15, scale: 2, default: 0.0
    t.decimal  "priceLessPrevious", precision: 15, scale: 2, default: 0.0
    t.integer  "order"
    t.boolean  "refunded",                                   default: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "domain"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
