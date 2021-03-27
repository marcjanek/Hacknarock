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

ActiveRecord::Schema.define(version: 2021_03_27_190311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interests", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "interests_people", id: false, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "interest_id", null: false
  end

  create_table "meetings", force: :cascade do |t|
    t.string "uuid"
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "meetings_people", id: false, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "meeting_id", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.decimal "age"
    t.boolean "gender"
    t.text "description"
    t.string "day"
    t.decimal "hour"
    t.decimal "group_size"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
