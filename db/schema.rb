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

ActiveRecord::Schema[7.1].define(version: 2024_08_05_224306) do
  create_table "analytics", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "body"
    t.index ["user_id"], name: "index_analytics_on_user_id"
  end

  create_table "analytics_chats", force: :cascade do |t|
    t.string "prompt_temperature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "x_username"
    t.integer "x_id"
    t.string "chat_type"
    t.index ["user_id"], name: "index_analytics_chats_on_user_id"
  end

  create_table "context_annotation_domains", force: :cascade do |t|
    t.integer "post_id", null: false
    t.string "domain_name"
    t.string "domain_description"
    t.string "entity_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "entity_description"
    t.index ["post_id"], name: "index_context_annotation_domains_on_post_id"
  end

  create_table "entities_annotations", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "start_location"
    t.integer "end_location"
    t.string "probability"
    t.string "annotation_type"
    t.string "normalized_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_entities_annotations_on_post_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "analytics_chat_id", null: false
    t.string "agent_response"
    t.string "user_prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analytics_chat_id"], name: "index_messages_on_analytics_chat_id"
  end

  create_table "post_mentions", force: :cascade do |t|
    t.string "mentioned_user_id"
    t.string "mentioned_username"
    t.integer "post_id", null: false
    t.integer "start_location"
    t.integer "end_location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_mentions_on_post_id"
  end

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
    t.string "lang"
    t.string "in_reply_to_user_id"
    t.integer "user_profile_clicks"
    t.integer "engagements"
    t.string "url"
    t.string "x_username"
    t.integer "x_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "public_analytics", force: :cascade do |t|
    t.string "x_username"
    t.integer "x_id"
    t.text "popular_tweet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["x_id"], name: "index_public_analytics_on_x_id"
  end

  create_table "user_posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_user_posts_on_post_id"
    t.index ["user_id"], name: "index_user_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "x_username"
    t.integer "x_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "x_access_token"
    t.string "x_access_token_secret"
    t.string "x_access_token_key"
    t.string "x_access_token_secret_key"
    t.boolean "protected"
    t.boolean "verified"
    t.string "pinned_tweet_id"
    t.string "profile_image_url"
    t.integer "followers_count"
    t.integer "following_count"
    t.integer "tweet_count"
    t.integer "listed_count"
    t.integer "like_count"
    t.text "description"
    t.string "location"
    t.string "x_account_created_at"
  end

  add_foreign_key "analytics", "users"
  add_foreign_key "analytics_chats", "users"
  add_foreign_key "context_annotation_domains", "posts"
  add_foreign_key "entities_annotations", "posts"
  add_foreign_key "messages", "analytics_chats"
  add_foreign_key "post_mentions", "posts"
  add_foreign_key "public_analytics", "posts", column: "x_id"
  add_foreign_key "user_posts", "posts"
  add_foreign_key "user_posts", "users"
end
