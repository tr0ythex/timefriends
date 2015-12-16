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

ActiveRecord::Schema.define(version: 20151216153309) do

  create_table "backgrounds", force: :cascade do |t|
    t.binary   "bg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "backgrounds_users", id: false, force: :cascade do |t|
    t.integer "user_id",       null: false
    t.integer "background_id", null: false
  end

  add_index "backgrounds_users", ["background_id"], name: "index_backgrounds_users_on_background_id"
  add_index "backgrounds_users", ["user_id"], name: "index_backgrounds_users_on_user_id"

  create_table "comments", force: :cascade do |t|
    t.string   "author"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id"

  create_table "friendships", force: :cascade do |t|
    t.integer  "friendable_id"
    t.string   "friendable_type"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blocker_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text     "body"
    t.time     "time"
    t.string   "place"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.boolean  "auto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "hide_acc",        default: false
    t.binary   "photo"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "auth_token"
  end

end
