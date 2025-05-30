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

ActiveRecord::Schema[8.0].define(version: 2025_04_12_163407) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "enqueued_jobs", force: :cascade do |t|
    t.string "queueable_type", null: false
    t.bigint "queueable_id", null: false
    t.string "provider_job_id", null: false
    t.string "job_class_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_class_name", "queueable_type", "queueable_id"], name: "idx_on_job_class_name_queueable_type_queueable_id_fd76086edf", unique: true
    t.index ["provider_job_id"], name: "index_enqueued_jobs_on_provider_job_id", unique: true
  end

  create_table "job_logs", force: :cascade do |t|
    t.string "job_id", null: false
    t.bigint "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_balances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "job_id"
    t.integer "lock_version", default: 0, null: false
    t.index ["user_id"], name: "index_user_balances_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "user_balances", "users"
end
