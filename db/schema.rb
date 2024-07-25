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

ActiveRecord::Schema[7.1].define(version: 2024_07_25_222240) do
  create_table "posts", force: :cascade do |t|
    t.string "post_id"
    t.text "text"
    t.integer "retweet_count"
    t.integer "reply_count"
    t.integer "like_count"
    t.integer "quote_count"
    t.integer "bookmark_count"
    t.integer "impression_count"
    t.datetime "post_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "x_username"
    t.integer "x_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
