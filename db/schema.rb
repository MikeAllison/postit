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

ActiveRecord::Schema.define(version: 20160908001249) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "unhidden_posts_count"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug"

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tallied_votes"
    t.boolean  "hidden"
    t.integer  "total_flags"
  end

  add_index "comments", ["created_at"], name: "index_comments_on_created_at"
  add_index "comments", ["post_id"], name: "index_comments_on_post_id"
  add_index "comments", ["tallied_votes", "created_at"], name: "index_comments_on_tallied_votes_and_created_at"
  add_index "comments", ["total_flags"], name: "index_comments_on_total_flags"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "flags", force: true do |t|
    t.boolean  "flag"
    t.integer  "user_id"
    t.integer  "flagable_id"
    t.string   "flagable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags", ["flagable_id", "flagable_type"], name: "index_flags_on_flagable_id_and_flagable_type"
  add_index "flags", ["user_id", "flag"], name: "index_flags_on_user_id_and_flag"
  add_index "flags", ["user_id"], name: "index_flags_on_user_id"

  create_table "post_categories", force: true do |t|
    t.integer  "post_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_categories", ["category_id"], name: "index_post_categories_on_category_id"
  add_index "post_categories", ["post_id"], name: "index_post_categories_on_post_id"

  create_table "posts", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "tallied_votes"
    t.boolean  "hidden"
    t.integer  "total_flags"
    t.integer  "unhidden_comments_count"
  end

  add_index "posts", ["created_at"], name: "index_posts_on_created_at"
  add_index "posts", ["slug"], name: "index_posts_on_slug"
  add_index "posts", ["tallied_votes", "created_at"], name: "index_posts_on_tallied_votes_and_created_at"
  add_index "posts", ["total_flags"], name: "index_posts_on_total_flags"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "slug"
    t.string   "time_zone"
    t.integer  "role"
    t.boolean  "disabled"
  end

  add_index "users", ["slug"], name: "index_users_on_slug"

  create_table "votes", force: true do |t|
    t.boolean  "vote"
    t.integer  "user_id"
    t.integer  "voteable_id"
    t.string   "voteable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id"
  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type"

end
