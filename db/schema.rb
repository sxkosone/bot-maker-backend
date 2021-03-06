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

ActiveRecord::Schema.define(version: 2018_09_12_182621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bots", force: :cascade do |t|
    t.string "name"
    t.string "url_id"
    t.integer "user_id"
    t.boolean "include_default_scripts"
    t.string "description"
    t.boolean "include_classifier"
  end

  create_table "classifier_responses", force: :cascade do |t|
    t.integer "bot_id"
    t.string "text"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classifiers", force: :cascade do |t|
    t.binary "saved"
    t.integer "bot_id"
    t.string "category_1"
    t.string "category_2"
    t.text "data_1"
    t.text "data_2"
  end

  create_table "fallbacks", force: :cascade do |t|
    t.string "text"
    t.integer "bot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responses", force: :cascade do |t|
    t.integer "trigger_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "triggers", force: :cascade do |t|
    t.integer "bot_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
