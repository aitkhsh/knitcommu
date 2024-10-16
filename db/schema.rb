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

ActiveRecord::Schema[7.2].define(version: 2024_10_10_160854) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "profile_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_comments_on_profile_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "profiletags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_profiletags_on_profile_id"
    t.index ["tag_id", "profile_id"], name: "index_profiletags_on_tag_id_and_profile_id", unique: true
    t.index ["tag_id"], name: "index_profiletags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remote_avatar_url"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "comments", "profiles"
  add_foreign_key "comments", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "profiletags", "profiles"
  add_foreign_key "profiletags", "tags"
end
