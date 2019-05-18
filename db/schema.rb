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

ActiveRecord::Schema.define(version: 20190501111327) do

  create_table "cities", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "prefecture_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "districts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "prefecture_id"
    t.integer "city_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_districts_on_city_id"
    t.index ["prefecture_id"], name: "index_districts_on_prefecture_id"
  end

  create_table "hotsprings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "image_url"
  end

  create_table "prefectures", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type"
    t.integer "user_id"
    t.integer "hotspring_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotspring_id"], name: "index_relationships_on_hotspring_id"
    t.index ["user_id", "hotspring_id", "type"], name: "index_relationships_on_user_id_and_hotspring_id_and_type", unique: true
    t.index ["user_id"], name: "index_relationships_on_user_id"
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "hotspring_id"
    t.string "title"
    t.text "comment"
    t.float "satisfaction_degree", limit: 24
    t.date "visit_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotspring_id"], name: "index_reviews_on_hotspring_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cities", "prefectures"
  add_foreign_key "districts", "cities"
  add_foreign_key "districts", "prefectures"
  add_foreign_key "relationships", "hotsprings"
  add_foreign_key "relationships", "users"
  add_foreign_key "reviews", "hotsprings"
  add_foreign_key "reviews", "users"
end
