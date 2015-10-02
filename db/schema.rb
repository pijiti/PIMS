# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151002031332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batches", force: true do |t|
    t.decimal  "qty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "expiry_date"
    t.string   "batch_number"
    t.date     "mfd_date"
    t.string   "comment",           limit: 500
    t.boolean  "approved",                                              default: false,              null: false
    t.integer  "supply_id"
    t.integer  "brand_id"
    t.integer  "pharm_item_id"
    t.decimal  "rate",                          precision: 8, scale: 2
    t.integer  "giver_store"
    t.integer  "recipient_store"
    t.string   "unapproved_reason"
    t.integer  "prescription_id"
    t.integer  "request_item_id"
    t.decimal  "dispensable_qty",               precision: 8, scale: 2
    t.decimal  "retail_price",                  precision: 8, scale: 2
    t.text     "comments"
    t.string   "approval_status",                                       default: "PENDING APPROVAL"
    t.decimal  "loose_units"
  end

  create_table "brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pharm_item_id"
    t.integer  "marketer_id"
    t.integer  "unit_dose_id"
    t.string   "concentration"
    t.integer  "item_concentration_unit_id"
    t.string   "pack_size"
    t.decimal  "min_dispensable",            precision: 5, scale: 2
    t.integer  "pack_bundle"
  end

  create_table "collation_batches", force: true do |t|
    t.integer  "prescription_batch_id"
    t.integer  "inventory_batch_id"
    t.string   "units"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "hospital_units", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", force: true do |t|
    t.integer  "brand_id"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "qty_last_added"
    t.float    "rate_per_unit"
    t.integer  "pharm_item_id"
  end

  create_table "inventory_batches", force: true do |t|
    t.integer  "inventory_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "units"
    t.boolean  "expired"
  end

  create_table "item_classes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "item_concentration_units", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "item_supplies", force: true do |t|
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supply_id"
    t.decimal  "rate",          precision: 6, scale: 2
    t.integer  "pharm_item_id"
  end

  create_table "itemclass_pharmitems", force: true do |t|
    t.integer  "item_class_id"
    t.integer  "pharm_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locals", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lost_drugs", force: true do |t|
    t.string   "lost_qty"
    t.integer  "receipt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marketers", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.boolean  "foreign",     default: false, null: false
  end

  create_table "organisations", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.binary   "logo"
    t.string   "contact_person"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_phone"
    t.string   "contact_email"
  end

  create_table "patients", force: true do |t|
    t.integer  "age"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "title_id"
    t.string   "hospital_number"
    t.string   "firstname"
    t.string   "surname"
    t.integer  "gender",          default: 0, null: false
    t.string   "nok_name"
    t.string   "nok_mobile"
  end

  create_table "pharm_item_sub_classes", force: true do |t|
    t.integer  "pharm_item_id"
    t.integer  "sub_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pharm_item_sub_classes", ["pharm_item_id"], name: "index_pharm_item_sub_classes_on_pharm_item_id", using: :btree
  add_index "pharm_item_sub_classes", ["sub_class_id"], name: "index_pharm_item_sub_classes_on_sub_class_id", using: :btree

  create_table "pharm_items", force: true do |t|
    t.string   "name"
    t.integer  "number_of_brands"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_class_id"
    t.decimal  "central_restock_level",     precision: 8, scale: 2
    t.decimal  "central_critical_level",    precision: 8, scale: 2
    t.decimal  "main_restock_level",        precision: 8, scale: 2
    t.decimal  "main_critical_level",       precision: 8, scale: 2
    t.decimal  "dispensary_restock_level",  precision: 8, scale: 2
    t.decimal  "dispensary_critical_level", precision: 8, scale: 2
    t.decimal  "ward_restock_level",        precision: 8, scale: 2
    t.decimal  "ward_critical_level",       precision: 8, scale: 2
  end

  create_table "pharm_items_sub_classes", force: true do |t|
    t.integer "pharm_item_id"
    t.integer "sub_class_id"
  end

  create_table "pims_configs", force: true do |t|
    t.string   "property_name"
    t.string   "property_value"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prescription_batches", force: true do |t|
    t.integer  "pharm_item_id"
    t.integer  "brand_id"
    t.string   "rate"
    t.string   "qty"
    t.string   "batch_number"
    t.text     "comment"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "prescription_id"
    t.integer  "store_id"
  end

  create_table "prescriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "hospital_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id"
    t.string   "code"
    t.integer  "doctor_id"
    t.datetime "prescription_date"
    t.string   "subtotal"
    t.string   "total"
    t.string   "surcharges"
    t.string   "surcharges_name"
    t.string   "status"
  end

  create_table "receipts", force: true do |t|
    t.integer  "batch_id"
    t.integer  "inventory_id"
    t.integer  "from_store_id"
    t.integer  "qty"
    t.string   "confirm_receipt"
    t.integer  "received_qty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "to_store_id"
    t.integer  "service_request_id"
    t.string   "lost_reason"
    t.text     "comments"
  end

  create_table "request_items", force: true do |t|
    t.integer  "pharm_item_id"
    t.decimal  "qty",           precision: 5, scale: 2
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "request_id"
  end

  add_index "request_items", ["pharm_item_id"], name: "index_request_items_on_pharm_item_id", using: :btree

  create_table "requests", force: true do |t|
    t.string   "request_code"
    t.integer  "store_id"
    t.integer  "user_id"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["store_id"], name: "index_requests_on_store_id", using: :btree
  add_index "requests", ["user_id"], name: "index_requests_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "service_requests", force: true do |t|
    t.integer  "request_store_id"
    t.integer  "from_store_id"
    t.float    "qty"
    t.integer  "pharm_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",           default: "PENDING"
    t.integer  "brand_id"
  end

  create_table "staff_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "store_operations", force: true do |t|
    t.string   "name"
    t.boolean  "payment_required"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "store_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "stores", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.time     "open_time"
    t.time     "close_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parent_store"
    t.integer  "parent_id"
    t.integer  "store_type_id"
    t.integer  "store_operation_id"
    t.text     "store_roles"
  end

  create_table "sub_classes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "item_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_classes", ["item_class_id"], name: "index_sub_classes_on_item_class_id", using: :btree

  create_table "supplies", force: true do |t|
    t.integer  "vendor_id"
    t.string   "invoice_reference"
    t.date     "invoice_date"
    t.decimal  "invoice_value",     precision: 10, scale: 2
    t.integer  "signed_off_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "store_id"
    t.string   "approval_status"
    t.datetime "approval_sent"
    t.datetime "approved"
    t.integer  "approved_by"
    t.integer  "disapprove_count"
    t.string   "workflow_state"
    t.datetime "last_disapproved"
  end

  create_table "surcharge_items", force: true do |t|
    t.text     "description"
    t.decimal  "value",        precision: 4, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "surcharge_id"
    t.string   "name"
  end

  create_table "surcharges", force: true do |t|
    t.boolean  "active",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "charge_type"
    t.string   "name"
  end

  create_table "titles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_doses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "form_type"
  end

  create_table "user_profiles", force: true do |t|
    t.integer  "gender_id"
    t.date     "DoB"
    t.string   "address"
    t.string   "next_of_kin"
    t.string   "next_of_kin_mobile"
    t.integer  "state_id"
    t.integer  "local_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "title_id"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.integer  "store_id"
    t.integer  "role_id"
    t.integer  "staff_category_id"
    t.string   "validity"
    t.datetime "valid_duration"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "vendor_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendors", force: true do |t|
    t.text     "name"
    t.text     "address"
    t.string   "contact_name"
    t.string   "contact_mobile",     limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_category_id"
    t.string   "reg_number",         limit: 15
    t.integer  "state_id"
    t.string   "contact_email",      limit: 25
    t.integer  "store_id"
  end

end
