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

ActiveRecord::Schema.define(version: 2020_12_13_212952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventories", force: :cascade do |t|
    t.bigint "shoe_id", null: false
    t.bigint "store_id", null: false
    t.integer "quantity", default: 1, comment: "Quantity in stock"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shoe_id", "store_id"], name: "index_inventories_on_shoe_id_and_store_id", unique: true
    t.index ["shoe_id"], name: "index_inventories_on_shoe_id"
    t.index ["store_id"], name: "index_inventories_on_store_id"
  end

  create_table "shoes", force: :cascade do |t|
    t.string "model", comment: "Model name of the shoe"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["model"], name: "index_shoes_on_model", unique: true
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", comment: "Name of the store"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_stores_on_name", unique: true
  end

  add_foreign_key "inventories", "shoes"
  add_foreign_key "inventories", "stores"
end
