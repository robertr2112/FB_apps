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

ActiveRecord::Schema.define(version: 20130911180054) do

  create_table "entries", force: true do |t|
    t.integer  "pool_id"
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "survivorStatusIn", default: true
    t.integer  "supTotalPoints",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["pool_id"], name: "index_entries_on_pool_id", using: :btree
  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "game_picks", force: true do |t|
    t.integer  "pick_id"
    t.integer  "chosenTeamIndex"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "homeTeamIndex"
    t.integer  "awayTeamIndex"
    t.integer  "spread"
    t.integer  "week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "homeTeamScore", default: 0
    t.integer  "awayTeamScore", default: 0
  end

  create_table "picks", force: true do |t|
    t.integer  "week_id"
    t.integer  "entry_id"
    t.integer  "weekNumber"
    t.integer  "totalScore", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "picks", ["entry_id"], name: "index_picks_on_entry_id", using: :btree

  create_table "pool_memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "pool_id"
    t.boolean  "owner",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pools", force: true do |t|
    t.string   "name"
    t.integer  "poolType"
    t.boolean  "allowMulti",      default: false
    t.boolean  "isPublic",        default: true
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.boolean  "nfl"
    t.string   "imagePath"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "admin",                  default: false
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "confirmation_token"
    t.boolean  "confirmed",              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "weeks", force: true do |t|
    t.integer  "state"
    t.integer  "pool_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weekNumber"
  end

end
