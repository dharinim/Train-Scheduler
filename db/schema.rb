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

ActiveRecord::Schema.define(version: 20170624225525) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dispatchers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "day_of_the_week"
    t.time "departure_time"
    t.integer "occurance"
    t.integer "occurance_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "train_schedules", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.bigint "train_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_train_schedules_on_schedule_id"
    t.index ["train_id"], name: "index_train_schedules_on_train_id"
  end

  create_table "trains", force: :cascade do |t|
    t.integer "from_city_id"
    t.integer "to_city_id"
    t.integer "seats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dispatcher_id"
  end

end
