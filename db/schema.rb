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

ActiveRecord::Schema[7.1].define(version: 2024_09_17_113424) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_controls", force: :cascade do |t|
    t.boolean "active"
    t.datetime "active_from"
    t.datetime "active_until"
    t.string "controlable_type", null: false
    t.bigint "controlable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controlable_type", "controlable_id"], name: "index_access_controls_on_controlable"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "compliment"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalog_categories", force: :cascade do |t|
    t.string "title", limit: 64, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalog_categories_catalogs", id: false, force: :cascade do |t|
    t.bigint "catalog_id", null: false
    t.bigint "catalog_category_id", null: false
    t.index ["catalog_id", "catalog_category_id"], name: "idx_on_catalog_id_catalog_category_id_fa3146f165"
  end

  create_table "catalogs", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "catalogable_type"
    t.bigint "catalogable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "profit_rate", precision: 18, scale: 2, default: "0.0", null: false
    t.boolean "show", default: false, null: false
    t.index ["catalogable_type", "catalogable_id"], name: "index_catalogs_on_catalogable"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 128, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.integer "total_items", default: 0, null: false
    t.date "validity", null: false
    t.string "brand", limit: 255
    t.bigint "stock_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_entries_on_stock_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "catalog_id", null: false
    t.bigint "category_id", null: false
    t.index ["catalog_id"], name: "index_items_on_catalog_id"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["stock_id"], name: "index_items_on_stock_id"
  end

  create_table "measures", force: :cascade do |t|
    t.decimal "quantity", precision: 18, scale: 2, null: false
    t.string "base_unit", default: "g", null: false
    t.string "kind", limit: 32, default: "total"
    t.bigint "unit_id", null: false
    t.string "measurable_type"
    t.bigint "measurable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measurable_type", "measurable_id"], name: "index_measures_on_measurable"
    t.index ["unit_id"], name: "index_measures_on_unit_id"
  end

  create_table "organization_addresses", id: false, force: :cascade do |t|
    t.bigint "address_id", null: false
    t.bigint "organization_id", null: false
    t.index ["address_id"], name: "index_organization_addresses_on_address_id"
    t.index ["organization_id", "address_id"], name: "index_organization_addresses_on_organization_id_and_address_id"
    t.index ["organization_id"], name: "index_organization_addresses_on_organization_id"
  end

  create_table "organization_permissions", id: false, force: :cascade do |t|
    t.bigint "permission_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "permission_id"], name: "idx_on_organization_id_permission_id_67bb288112"
    t.index ["organization_id"], name: "index_organization_permissions_on_organization_id"
    t.index ["permission_id"], name: "index_organization_permissions_on_permission_id"
  end

  create_table "organization_permissions_roles", id: false, force: :cascade do |t|
    t.bigint "organization_role_id", null: false
    t.bigint "organization_permission_id", null: false
    t.index ["organization_role_id", "organization_permission_id"], name: "idx_on_organization_role_id_organization_permission_0a03d728d9"
  end

  create_table "organization_phones", id: false, force: :cascade do |t|
    t.bigint "phone_id", null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id", "phone_id"], name: "index_organization_phones_on_organization_id_and_phone_id"
    t.index ["organization_id"], name: "index_organization_phones_on_organization_id"
    t.index ["phone_id"], name: "index_organization_phones_on_phone_id"
  end

  create_table "organization_profiles", force: :cascade do |t|
    t.string "slogan", limit: 255, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_profiles_on_organization_id"
  end

  create_table "organization_roles", id: false, force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "role_id"], name: "index_organization_roles_on_organization_id_and_role_id"
    t.index ["organization_id"], name: "index_organization_roles_on_organization_id"
    t.index ["role_id"], name: "index_organization_roles_on_role_id"
  end

  create_table "organization_user_roles", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_organization_user_roles_on_role_id"
  end

  create_table "organization_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.boolean "principal", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "user_id"], name: "index_organization_users_on_organization_id_and_user_id"
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "domain", limit: 255, null: false
    t.string "email", limit: 255, null: false
    t.string "code", limit: 64, null: false
    t.string "government_number", limit: 32
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_organizations_on_email"
    t.index ["name", "code", "domain"], name: "index_organizations_on_name_and_code_and_domain"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.string "scope", limit: 400, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phones", force: :cascade do |t|
    t.string "country_code"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "BRL", null: false
    t.string "category", limit: 255, null: false
    t.string "priceable_type"
    t.bigint "priceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priceable_type", "priceable_id"], name: "index_prices_on_priceable"
  end

  create_table "product_sale_items", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "product_sale_id"
    t.integer "total_items"
    t.boolean "use_default_price", default: false, null: false
    t.decimal "profit_rate", precision: 18, scale: 2, null: false
    t.string "category", limit: 32, default: "sale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "product_sale_id"], name: "index_product_sale_items_on_product_id_and_product_sale_id"
    t.index ["product_id"], name: "index_product_sale_items_on_product_id"
    t.index ["product_sale_id"], name: "index_product_sale_items_on_product_sale_id"
  end

  create_table "product_sales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.boolean "show_on_site", default: false
    t.integer "total_items"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profile_addresses", id: false, force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.bigint "address_id", null: false
    t.index ["address_id"], name: "index_profile_addresses_on_address_id"
    t.index ["profile_id", "address_id"], name: "index_profile_addresses_on_profile_id_and_address_id"
    t.index ["profile_id"], name: "index_profile_addresses_on_profile_id"
  end

  create_table "profile_phones", id: false, force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.bigint "phone_id", null: false
    t.index ["phone_id"], name: "index_profile_phones_on_phone_id"
    t.index ["profile_id", "phone_id"], name: "index_profile_phones_on_profile_id_and_phone_id"
    t.index ["profile_id"], name: "index_profile_phones_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.string "middle_name", limit: 255
    t.date "birthdate", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "role_permissions", id: false, force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_role_permissions_on_role_id_and_permission_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales", force: :cascade do |t|
    t.string "saleable_type"
    t.bigint "saleable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["saleable_type", "saleable_id"], name: "index_sales_on_saleable"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "minimum_stock_level", default: 0
    t.integer "maximum_stock_level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stocks_on_name"
  end

  create_table "units", force: :cascade do |t|
    t.string "long_name", limit: 255, null: false
    t.string "short_name", limit: 3, null: false
    t.integer "quantity", null: false
    t.integer "unit_type", default: 0, null: false
    t.boolean "is_default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_type", "is_default"], name: "index_units_on_unit_type_and_is_default", unique: true
  end

  create_table "user_roles", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "force_password_change", default: true, null: false
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 512, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "entries", "stocks"
  add_foreign_key "items", "catalogs"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "stocks"
  add_foreign_key "measures", "units"
  add_foreign_key "organization_addresses", "addresses"
  add_foreign_key "organization_addresses", "organizations"
  add_foreign_key "organization_permissions", "organizations"
  add_foreign_key "organization_permissions", "permissions"
  add_foreign_key "organization_phones", "organizations"
  add_foreign_key "organization_phones", "phones"
  add_foreign_key "organization_profiles", "organizations"
  add_foreign_key "organization_roles", "organizations"
  add_foreign_key "organization_roles", "roles"
  add_foreign_key "organization_user_roles", "roles"
  add_foreign_key "organization_users", "organizations", on_delete: :cascade
  add_foreign_key "organization_users", "users", on_delete: :cascade
  add_foreign_key "profile_addresses", "addresses"
  add_foreign_key "profile_addresses", "profiles"
  add_foreign_key "profile_phones", "phones"
  add_foreign_key "profile_phones", "profiles"
  add_foreign_key "profiles", "users", on_delete: :cascade
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
