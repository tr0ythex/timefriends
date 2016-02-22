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

ActiveRecord::Schema.define(version: 20160222084717) do

  create_table "accessions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "accessions", ["post_id"], name: "index_accessions_on_post_id"
  add_index "accessions", ["user_id"], name: "index_accessions_on_user_id"

  create_table "backgrounds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "bg_url"
    t.integer  "bg_pack_id"
  end

  add_index "backgrounds", ["bg_pack_id"], name: "index_backgrounds_on_bg_pack_id"

  create_table "bg_packs", force: :cascade do |t|
    t.string   "device_type"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "bg_packs_users", id: false, force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "bg_pack_id", null: false
  end

  add_index "bg_packs_users", ["bg_pack_id"], name: "index_bg_packs_users_on_bg_pack_id"
  add_index "bg_packs_users", ["user_id"], name: "index_bg_packs_users_on_user_id"

  create_table "comments", force: :cascade do |t|
    t.string   "author"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id"

  create_table "devices", force: :cascade do |t|
    t.string   "registration_id"
    t.string   "device_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

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
    t.datetime "start_time"
    t.string   "place"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.boolean  "auto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.datetime "end_time"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "hide_acc",           default: false
    t.string   "photo_url"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "auth_token"
    t.string   "vkid"
    t.string   "background_url"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

end
