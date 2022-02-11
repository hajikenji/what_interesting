# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_09_084153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_statistics", force: :cascade do |t|
    t.string "comment"
    t.integer "fav"
    t.integer "comment_fav"
    t.integer "quote"
    t.bigint "article_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_article_statistics_on_article_id", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "link", null: false
    t.text "icon"
    t.integer "ranking"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["link"], name: "index_articles_on_link", unique: true
  end

  add_foreign_key "article_statistics", "articles"
end
