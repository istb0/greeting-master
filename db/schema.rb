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

ActiveRecord::Schema.define(version: 2022_02_23_091249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feedbacks", force: :cascade do |t|
    t.string "comment", limit: 255, null: false
    t.integer "max_score", null: false
    t.integer "emotion_type", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "greetings", force: :cascade do |t|
    t.string "phrase", limit: 50, null: false
    t.string "subtitle", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "results", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.integer "score", null: false
    t.integer "calm", null: false
    t.integer "anger", null: false
    t.integer "joy", null: false
    t.integer "sorrow", null: false
    t.integer "energy", null: false
    t.bigint "greeting_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["greeting_id"], name: "index_results_on_greeting_id"
  end

  add_foreign_key "results", "greetings"
end
