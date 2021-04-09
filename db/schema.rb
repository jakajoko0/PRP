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

ActiveRecord::Schema.define(version: 2021_03_25_161857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accountants", force: :cascade do |t|
    t.bigint "franchise_id"
    t.string "accountant_num", null: false
    t.string "lastname", null: false
    t.string "firstname", null: false
    t.string "initial"
    t.string "salutation"
    t.date "birthdate"
    t.string "spouse_name"
    t.date "spouse_birthdate"
    t.integer "spouse_partner"
    t.date "start_date"
    t.integer "inactive"
    t.date "term_date"
    t.integer "cpa"
    t.integer "mba"
    t.integer "degree"
    t.integer "agent"
    t.integer "advisory_board"
    t.text "notes"
    t.string "slug"
    t.string "ptin", limit: 8
    t.index ["accountant_num", "franchise_id"], name: "index_accountants_on_accountant_num_and_franchise_id", unique: true
    t.index ["franchise_id"], name: "index_accountants_on_franchise_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.string "time_zone", default: "UTC"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.bigint "franchise_id"
    t.string "bank_name"
    t.string "last_four"
    t.string "account_type"
    t.string "bank_token"
    t.string "slug"
    t.index ["franchise_id"], name: "index_bank_accounts_on_franchise_id"
  end

  create_table "bank_routings", force: :cascade do |t|
    t.string "routing"
    t.string "office_code"
    t.string "fbr"
    t.string "record_type"
    t.string "change_date"
    t.string "new_routing"
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "zip_ext"
    t.string "area_code"
    t.string "prefix"
    t.string "suffix"
    t.string "status_code"
    t.string "master_state"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.bigint "franchise_id"
    t.string "card_type"
    t.string "last_four"
    t.integer "exp_year"
    t.integer "exp_month"
    t.string "card_token"
    t.string "slug"
    t.index ["franchise_id"], name: "index_credit_cards_on_franchise_id"
  end

  create_table "event_logs", force: :cascade do |t|
    t.date "event_date"
    t.string "fran"
    t.string "lastname"
    t.string "event_desc"
    t.string "user_email"
  end

  create_table "financials", force: :cascade do |t|
    t.bigint "franchise_id"
    t.integer "year"
    t.decimal "acct_monthly", precision: 12, scale: 2, default: "0.0"
    t.decimal "acct_startup", precision: 12, scale: 2, default: "0.0"
    t.decimal "acct_backwork", precision: 12, scale: 2, default: "0.0"
    t.decimal "tax_prep", precision: 12, scale: 2, default: "0.0"
    t.decimal "payroll_processing", precision: 12, scale: 2, default: "0.0"
    t.decimal "other_consult", precision: 12, scale: 2, default: "0.0"
    t.decimal "payroll_operation", precision: 12, scale: 2, default: "0.0"
    t.decimal "owner_wages", precision: 12, scale: 2, default: "0.0"
    t.decimal "owner_payroll_taxes", precision: 12, scale: 2, default: "0.0"
    t.decimal "payroll_taxes_ben_ee", precision: 12, scale: 2, default: "0.0"
    t.decimal "insurance_business", precision: 12, scale: 2, default: "0.0"
    t.decimal "supplies", precision: 12, scale: 2, default: "0.0"
    t.decimal "legal_accounting", precision: 12, scale: 2, default: "0.0"
    t.decimal "marketing", precision: 12, scale: 2, default: "0.0"
    t.decimal "rent", precision: 12, scale: 2, default: "0.0"
    t.decimal "outside_labor", precision: 12, scale: 2, default: "0.0"
    t.decimal "vehicles", precision: 12, scale: 2, default: "0.0"
    t.decimal "travel", precision: 12, scale: 2, default: "0.0"
    t.decimal "utilities", precision: 12, scale: 2, default: "0.0"
    t.decimal "licenses_taxes", precision: 12, scale: 2, default: "0.0"
    t.decimal "postage", precision: 12, scale: 2, default: "0.0"
    t.decimal "repairs", precision: 12, scale: 2, default: "0.0"
    t.decimal "interests", precision: 12, scale: 2, default: "0.0"
    t.decimal "meals_entertainment", precision: 12, scale: 2, default: "0.0"
    t.decimal "bank_charges", precision: 12, scale: 2, default: "0.0"
    t.decimal "contributions", precision: 12, scale: 2, default: "0.0"
    t.decimal "office", precision: 12, scale: 2, default: "0.0"
    t.decimal "miscellaneous", precision: 12, scale: 2, default: "0.0"
    t.decimal "equipment_lease", precision: 12, scale: 2, default: "0.0"
    t.decimal "dues_subscriptions", precision: 12, scale: 2, default: "0.0"
    t.decimal "bad_debt", precision: 12, scale: 2, default: "0.0"
    t.decimal "continuing_ed", precision: 12, scale: 2, default: "0.0"
    t.decimal "property_tax", precision: 12, scale: 2, default: "0.0"
    t.decimal "telephone_data_internet", precision: 12, scale: 2, default: "0.0"
    t.decimal "software", precision: 12, scale: 2, default: "0.0"
    t.decimal "royalties", precision: 12, scale: 2, default: "0.0"
    t.decimal "marketing_material", precision: 12, scale: 2, default: "0.0"
    t.decimal "owner_health_ins", precision: 12, scale: 2, default: "0.0"
    t.decimal "owner_vehicle", precision: 12, scale: 2, default: "0.0"
    t.decimal "owner_ira_contrib", precision: 12, scale: 2, default: "0.0"
    t.decimal "amortization", precision: 12, scale: 2, default: "0.0"
    t.decimal "depreciation", precision: 12, scale: 2, default: "0.0"
    t.decimal "payroll_process_fees", precision: 12, scale: 2, default: "0.0"
    t.decimal "other_income", precision: 12, scale: 2, default: "0.0"
    t.decimal "interest_income", precision: 12, scale: 2, default: "0.0"
    t.decimal "net_gain_asset", precision: 12, scale: 2, default: "0.0"
    t.decimal "casualty_gain", precision: 12, scale: 2, default: "0.0"
    t.decimal "other_expense", precision: 12, scale: 2, default: "0.0"
    t.decimal "prov_income_tax", precision: 12, scale: 2, default: "0.0"
    t.string "other1_desc"
    t.decimal "other1", precision: 12, scale: 2, default: "0.0"
    t.string "other2_desc"
    t.decimal "other2", precision: 12, scale: 2, default: "0.0"
    t.string "other3_desc"
    t.decimal "other3", precision: 12, scale: 2, default: "0.0"
    t.integer "monthly_clients"
    t.decimal "total_monthly_fees", precision: 12, scale: 2, default: "0.0"
    t.integer "quarterly_clients"
    t.decimal "total_quarterly_fees", precision: 12, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["franchise_id"], name: "index_financials_on_franchise_id"
  end

  create_table "franchise_documents", force: :cascade do |t|
    t.bigint "franchise_id"
    t.string "description", null: false
    t.integer "document_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["franchise_id"], name: "index_franchise_documents_on_franchise_id"
  end

  create_table "franchises", force: :cascade do |t|
    t.string "area", null: false
    t.string "mast", null: false
    t.integer "region", null: false
    t.string "franchise_number", null: false
    t.string "office", null: false
    t.string "firm_id", null: false
    t.string "salutation"
    t.string "lastname", null: false
    t.string "firstname", null: false
    t.string "initial"
    t.string "address", null: false
    t.string "address2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "email", null: false
    t.string "ship_address"
    t.string "ship_address2"
    t.string "ship_city"
    t.string "ship_state"
    t.string "ship_zip_code"
    t.string "home_address"
    t.string "home_address2"
    t.string "home_city"
    t.string "home_state"
    t.string "home_zip_code"
    t.string "phone", null: false
    t.string "phone2"
    t.string "fax"
    t.string "mobile"
    t.string "alt_email"
    t.date "start_date"
    t.date "renew_date"
    t.date "term_date"
    t.string "salesman"
    t.string "territory"
    t.string "start_zip"
    t.string "stop_zip"
    t.decimal "prior_year_rebate", precision: 10, scale: 2, default: "0.0"
    t.decimal "advanced_rebate", precision: 10, scale: 2, default: "0.0"
    t.integer "show_exempt_collect", default: 0
    t.integer "inactive", default: 0
    t.integer "non_compliant", default: 0
    t.string "non_compliant_reason"
    t.decimal "max_collections", precision: 10, scale: 2, default: "0.0"
    t.decimal "avg_collections", precision: 10, scale: 2, default: "0.0"
    t.integer "max_coll_year"
    t.integer "max_coll_month"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "term_reason"
    t.string "slug"
    t.index ["area", "mast", "region", "franchise_number", "office", "email", "inactive"], name: "office_index", unique: true
    t.index ["franchise_number", "region", "office"], name: "index_franchises_on_franchise_number_and_region_and_office", unique: true
    t.index ["franchise_number"], name: "franchise_number"
  end

  create_table "insurances", force: :cascade do |t|
    t.bigint "franchise_id"
    t.integer "eo_insurance", default: 0
    t.integer "gen_insurance"
    t.integer "other_insurance", default: 0
    t.string "other_description"
    t.date "eo_expiration"
    t.date "gen_expiration"
    t.date "other_expiration"
    t.string "slug"
    t.integer "other2_insurance", default: 0
    t.string "other2_description"
    t.date "other2_expiration"
    t.index ["franchise_id"], name: "index_insurances_on_franchise_id"
  end

  create_table "prp_transactions", force: :cascade do |t|
    t.bigint "franchise_id"
    t.datetime "date_posted"
    t.integer "trans_type", null: false
    t.string "trans_code", null: false
    t.string "trans_description"
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "transactionable_type"
    t.bigint "transactionable_id"
    t.index ["franchise_id"], name: "index_prp_transactions_on_franchise_id"
    t.index ["transactionable_type", "transactionable_id"], name: "index_prp_transactions_on_transactionable"
  end

  create_table "regions", force: :cascade do |t|
    t.integer "region_id"
    t.string "region_number"
    t.string "area"
    t.string "description"
  end

  create_table "remittances", force: :cascade do |t|
    t.bigint "franchise_id"
    t.integer "year"
    t.integer "month"
    t.integer "status"
    t.datetime "date_received"
    t.datetime "date_posted"
    t.decimal "accounting", precision: 10, scale: 2, default: "0.0"
    t.decimal "backwork", precision: 10, scale: 2, default: "0.0"
    t.decimal "consulting", precision: 10, scale: 2, default: "0.0"
    t.decimal "excluded", precision: 10, scale: 2, default: "0.0"
    t.decimal "other1", precision: 10, scale: 2, default: "0.0"
    t.decimal "payroll", precision: 10, scale: 2, default: "0.0"
    t.decimal "setup", precision: 10, scale: 2, default: "0.0"
    t.decimal "tax_preparation", precision: 10, scale: 2, default: "0.0"
    t.decimal "calculated_royalty", precision: 10, scale: 2, default: "0.0"
    t.decimal "minimum_royalty", precision: 10, scale: 2, default: "0.0"
    t.decimal "royalty", precision: 10, scale: 2, default: "0.0"
    t.string "credit1"
    t.decimal "credit1_amount", precision: 10, scale: 2, default: "0.0"
    t.string "credit2"
    t.decimal "credit2_amount", precision: 10, scale: 2, default: "0.0"
    t.string "credit3"
    t.decimal "credit3_amount", precision: 10, scale: 2, default: "0.0"
    t.string "credit4"
    t.decimal "credit4_amount", precision: 10, scale: 2, default: "0.0"
    t.integer "late"
    t.string "late_reason"
    t.decimal "late_fees", precision: 10, scale: 2, default: "0.0"
    t.string "payroll_credit_desc"
    t.decimal "payroll_credit_amount", precision: 10, scale: 2
    t.integer "confirmation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "other2", precision: 10, scale: 2, default: "0.0"
    t.string "slug"
    t.decimal "total_due", precision: 10, scale: 2, default: "0.0"
    t.index ["franchise_id", "year", "month"], name: "index_remittances_on_franchise_id_and_year_and_month", unique: true
    t.index ["franchise_id"], name: "index_remittances_on_franchise_id"
    t.index ["month"], name: "index_remittances_on_month"
    t.index ["year"], name: "index_remittances_on_year"
  end

  create_table "transaction_codes", force: :cascade do |t|
    t.string "code"
    t.integer "trans_type"
    t.string "description"
    t.boolean "show_in_royalties", default: false, null: false
    t.boolean "show_in_invoicing", default: false, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.bigint "franchise_id", null: false
    t.integer "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.string "time_zone", default: "UTC"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["franchise_id"], name: "index_users_on_franchise_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "website_preferences", force: :cascade do |t|
    t.bigint "franchise_id"
    t.integer "website_preference"
    t.string "payment_token"
    t.integer "payment_method"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["franchise_id"], name: "index_website_preferences_on_franchise_id"
  end

  add_foreign_key "accountants", "franchises"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bank_accounts", "franchises"
  add_foreign_key "credit_cards", "franchises"
  add_foreign_key "financials", "franchises"
  add_foreign_key "franchise_documents", "franchises"
  add_foreign_key "insurances", "franchises"
  add_foreign_key "prp_transactions", "franchises"
  add_foreign_key "remittances", "franchises"
  add_foreign_key "website_preferences", "franchises"
end
