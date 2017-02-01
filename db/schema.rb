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

ActiveRecord::Schema.define(version: 20170201081633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "backup_files", force: :cascade do |t|
    t.integer  "backup_id"
    t.string   "kind"
    t.string   "parent_dir"
    t.string   "path"
    t.string   "name"
    t.string   "file_type"
    t.integer  "file_size"
    t.datetime "last_modified"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "status"
    t.index ["backup_id"], name: "index_backup_files_on_backup_id", using: :btree
    t.index ["status"], name: "index_backup_files_on_status", using: :btree
  end

  create_table "backups", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "version",             default: 0
    t.datetime "backup_time"
    t.integer  "file_count",          default: 0
    t.integer  "new_file_count",      default: 0
    t.integer  "modified_file_count", default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["profile_id"], name: "index_backups_on_profile_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "backup_dirs"
    t.text     "backup_exclusion_dirs"
    t.datetime "last_backup"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "storage_size",          default: 0
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "backup_files", "backups"
  add_foreign_key "backups", "profiles"
  add_foreign_key "profiles", "users"
end
