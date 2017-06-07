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

ActiveRecord::Schema.define(version: 20170607154655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_resources", force: :cascade do |t|
    t.integer  "resource_id"
    t.string   "resource_klass"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "permission_type",             default: 0
    t.boolean  "can_access",                  default: true
    t.string   "unregistered_u_k", limit: 20
    t.index ["resource_id", "resource_klass", "user_id"], name: "access_resources_index2", using: :btree
    t.index ["user_id", "resource_id", "resource_klass"], name: "access_resources1", unique: true, using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "email"
    t.string   "postal_address"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",            limit: 20
    t.integer  "user_id"
    t.text     "info"
    t.boolean  "is_person",                 default: true
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "entity_id"
    t.string   "ein_or_ssn"
    t.string   "honorific",      limit: 10
    t.boolean  "is_honorific",              default: false
    t.datetime "deleted_at"
    t.string   "client_type"
    t.index ["deleted_at"], name: "index_clients_on_deleted_at", using: :btree
  end

  create_table "cloudinary_images", force: :cascade do |t|
    t.integer  "property_id"
    t.string   "cl_image_public_id"
    t.integer  "cl_image_width"
    t.integer  "cl_image_height"
    t.string   "cl_image_format"
    t.string   "cl_image_url"
    t.string   "cl_image_url_secure"
    t.string   "cl_image_original_filename"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "class_name"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "deleted",                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",              limit: 20
    t.integer  "user_id"
    t.index ["key"], name: "index_comments_on_key", using: :btree
  end

  create_table "common_static_fields", force: :cascade do |t|
    t.string   "type_is"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["title"], name: "index_common_static_fields_on_title", using: :btree
    t.index ["type_is"], name: "index_common_static_fields_on_type_is", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.text     "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "contact_type"
    t.string   "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "object_title"
    t.string   "role"
    t.string   "company_name"
    t.string   "ein_or_ssn"
    t.string   "postal_address"
    t.text     "notes"
    t.datetime "deleted_at"
    t.boolean  "is_company",     default: false
    t.string   "legal_ending"
    t.index ["contact_type", "type_id"], name: "index_contacts_on_contact_type_and_type_id", using: :btree
    t.index ["deleted_at"], name: "index_contacts_on_deleted_at", using: :btree
    t.index ["email"], name: "index_contacts_on_email", using: :btree
  end

  create_table "counteroffers", force: :cascade do |t|
    t.integer  "transaction_property_offer_id"
    t.date     "offered_date"
    t.string   "offer_type"
    t.decimal  "offered_price",                 precision: 15, scale: 2
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "default_values", force: :cascade do |t|
    t.string   "entity_name"
    t.string   "attribute_name"
    t.string   "value"
    t.string   "value_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "mode"
  end

  create_table "dynamic_fields", force: :cascade do |t|
    t.string   "klass"
    t.text     "fields"
    t.text     "validation"
    t.text     "default_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entities", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.integer  "type_"
    t.string   "jurisdiction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "number_of_assets"
    t.integer  "total_membership_interest",             default: 100
    t.integer  "total_undivided_interest",              default: 100
    t.integer  "total_partnership_interest",            default: 100
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "email"
    t.string   "ein_or_ssn"
    t.string   "postal_address"
    t.boolean  "s_corp_status",                         default: false
    t.boolean  "not_for_profit_status",                 default: false
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "key",                        limit: 20
    t.date     "date_of_formation"
    t.string   "legal_ending"
    t.string   "honorific",                  limit: 10
    t.boolean  "is_honorific",                          default: false
    t.string   "name2"
    t.string   "postal_address2"
    t.string   "city2"
    t.string   "state2"
    t.string   "zip2"
    t.string   "country"
    t.date     "date_of_appointment"
    t.date     "date_of_commission"
    t.string   "index"
    t.string   "country2"
    t.integer  "part",                       limit: 2
    t.string   "county"
    t.integer  "property_id"
    t.integer  "number_of_share"
    t.datetime "deleted_at"
    t.string   "first_name2"
    t.string   "last_name2"
    t.string   "judge_first_name"
    t.string   "judge_last_name"
    t.string   "guardian_first_name"
    t.string   "guardian_last_name"
    t.string   "notes"
    t.boolean  "m_date_of_formation",                   default: false
    t.boolean  "m_date_of_appointment",                 default: false
    t.boolean  "m_date_of_commission",                  default: false
    t.integer  "user_id"
    t.boolean  "has_comma",                             default: false
    t.integer  "shares_decimal_count"
    t.index ["deleted_at"], name: "index_entities_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_entities_on_user_id", using: :btree
  end

  create_table "group_members", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "gmember_type"
    t.integer  "gmember_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["group_id", "gmember_id", "gmember_type"], name: "index_group_members_on_group_id_and_gmember_id_and_gmember_type", unique: true, using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id",  default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "gtype",                  null: false
  end

  create_table "keys", force: :cascade do |t|
    t.string   "key"
    t.boolean  "used",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "uuid_decimal", precision: 25
    t.index ["key", "used"], name: "index_keys_on_key_and_used", using: :btree
    t.index ["key"], name: "index_keys_on_key", unique: true, using: :btree
    t.index ["uuid_decimal"], name: "index_keys_on_uuid_decimal", using: :btree
  end

  create_table "member_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "seen",       default: false
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "officers", force: :cascade do |t|
    t.text     "office"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "email"
    t.string   "postal_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",            limit: 20
    t.integer  "entity_id"
    t.string   "honorific",      limit: 10
    t.boolean  "is_honorific",              default: false
    t.string   "person_type"
  end

  create_table "parcels", force: :cascade do |t|
    t.string   "number"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["number"], name: "index_parcels_on_number", using: :btree
  end

  create_table "people_and_firms", force: :cascade do |t|
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "snail_mail_address"
    t.boolean  "tax_member",                                                    default: false
    t.boolean  "managing_member",                                               default: false
    t.boolean  "general_partner",                                               default: false
    t.string   "key",                       limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "member_type_id"
    t.integer  "resource_id"
    t.boolean  "is_person",                                                     default: false
    t.string   "first_name"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "ein_or_ssn"
    t.string   "postal_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "notes"
    t.string   "honorific"
    t.string   "is_honorific"
    t.bigint   "stock_share"
    t.integer  "entity_id"
    t.string   "class_name",                limit: 20
    t.decimal  "number_of_share",                      precision: 40, scale: 4
    t.integer  "my_percentage"
    t.decimal  "undivided_interest",                   precision: 40, scale: 4
    t.integer  "super_entity_id"
    t.boolean  "m_date_of_appointment",                                         default: false
    t.boolean  "m_date_of_formation",                                           default: false
    t.boolean  "m_date_of_commission",                                          default: false
    t.integer  "contact_id"
    t.string   "legal_ending"
    t.boolean  "has_comma",                                                     default: false
    t.string   "office"
    t.boolean  "is_manager",                                                    default: false
    t.string   "gender"
    t.decimal  "my_percentage_stockholder"
  end

  create_table "procedure_action_checklists", force: :cascade do |t|
    t.boolean  "checked",    default: false
    t.text     "title"
    t.integer  "action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedure_actions", force: :cascade do |t|
    t.text     "title"
    t.integer  "procedure_id"
    t.boolean  "deleted",                 default: false
    t.string   "key",          limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedures", force: :cascade do |t|
    t.text     "title"
    t.integer  "property_id"
    t.boolean  "deleted",                default: false
    t.string   "key",         limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.string   "type_is"
    t.integer  "transaction_are_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",                                                    limit: 20
    t.date     "start_date"
    t.string   "location_state"
    t.string   "location_city"
    t.string   "location_street_address"
    t.string   "county_street_address"
    t.string   "location_county"
    t.string   "county_tax_assessor_website"
    t.string   "county_tax_assessor_additional_info"
    t.string   "county_tax_assessor_district_website"
    t.string   "county_tax_assessor_district_additional_info"
    t.string   "tenant_contact_name"
    t.string   "tenant_contact_company"
    t.string   "tenant_contact_phone"
    t.string   "tenant_contact_email"
    t.string   "tenant_contact_fax"
    t.string   "tenant_contact_street_address"
    t.string   "tenant_contact_state"
    t.string   "tenant_contact_city"
    t.string   "lease_type_is"
    t.string   "lease_date_is"
    t.string   "building_status_is"
    t.date     "date_of_lease"
    t.string   "date_of_lease_details"
    t.date     "rent_commencement_date"
    t.string   "rent_commencement_date_details"
    t.integer  "number_of_years_in_term"
    t.integer  "number_of_option_period"
    t.integer  "length_of_option_period"
    t.text     "net_nature_of_lease"
    t.string   "tenant_state"
    t.string   "tenant_city"
    t.string   "tenant_county"
    t.string   "tenant_street_address"
    t.date     "closing_date"
    t.string   "tenants_store_number"
    t.boolean  "location_street_address_from_county_tax_authorities_is",                                     default: false
    t.text     "location_street_address_from_county_tax_authorities"
    t.datetime "deleted_at"
    t.string   "ownership_status"
    t.decimal  "price",                                                             precision: 15, scale: 2
    t.decimal  "current_rent",                                                      precision: 15, scale: 2
    t.decimal  "cap_rate",                                                          precision: 15, scale: 2
    t.boolean  "owner_person_is"
    t.integer  "owner_entity_id"
    t.integer  "owner_person_id"
    t.boolean  "m_closing_date",                                                                             default: false
    t.boolean  "m_date_of_lease",                                                                            default: false
    t.boolean  "m_rent_commencement_date",                                                                   default: false
    t.decimal  "lease_base_rent",                                                   precision: 15, scale: 2
    t.integer  "lease_duration_in_years"
    t.string   "lease_rent_increase_type"
    t.decimal  "lease_rent_increase_percentage",                                    precision: 5,  scale: 2
    t.integer  "lease_rent_slab_in_years"
    t.integer  "rent_table_version"
    t.string   "zip"
    t.string   "st_address_suffix"
    t.integer  "tenant_id"
    t.integer  "lease_slab_in_years"
    t.boolean  "lease_is_pro_rated",                                                                         default: false
    t.integer  "pro_rated_month"
    t.string   "pro_rated_month_name"
    t.integer  "pro_rated_year"
    t.integer  "pro_rated_day"
    t.date     "pro_rated_day_date"
    t.decimal  "pro_rated_day_rent",                                                precision: 15, scale: 2
    t.decimal  "pro_rated_month_rent",                                              precision: 15, scale: 2
    t.index ["deleted_at"], name: "index_properties_on_deleted_at", using: :btree
    t.index ["key"], name: "index_properties_on_key", using: :btree
  end

  create_table "qualified_intermediaries", force: :cascade do |t|
    t.string   "name"
    t.decimal  "currently_held",                  precision: 15, scale: 2
    t.decimal  "price",                           precision: 15, scale: 2
    t.text     "premises_address"
    t.string   "city",                 limit: 50
    t.string   "state",                limit: 20
    t.string   "country",              limit: 50
    t.string   "seller"
    t.string   "seller_entity_type"
    t.integer  "due_diligence_period"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
    t.string   "uuid",                 limit: 50
    t.index ["name"], name: "index_qualified_intermediaries_on_name", using: :btree
    t.index ["uuid"], name: "index_qualified_intermediaries_on_uuid", using: :btree
  end

  create_table "qualified_intermediary_deposits", force: :cascade do |t|
    t.integer  "qualified_intermediary_id"
    t.string   "title"
    t.decimal  "amount",                    precision: 15, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_tables", force: :cascade do |t|
    t.decimal  "rent",        precision: 15, scale: 2
    t.integer  "start_year"
    t.integer  "end_year"
    t.integer  "property_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "version"
    t.boolean  "is_option",                            default: false
    t.integer  "option_slab"
    t.string   "description"
    t.index ["property_id"], name: "index_rent_tables_on_property_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "tenants", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_mains", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "init",                                             default: false
    t.boolean  "purchase_only",                                    default: false
    t.decimal  "qi_funds",                precision: 15, scale: 2, default: "0.0"
    t.datetime "identification_deadline"
    t.datetime "transaction_deadline"
    t.decimal  "boot",                    precision: 15, scale: 2, default: "0.0"
  end

  create_table "transaction_personnels", force: :cascade do |t|
    t.integer  "transaction_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_properties", force: :cascade do |t|
    t.integer  "property_id"
    t.float    "sale_price"
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_sale"
    t.integer  "transaction_main_id"
    t.string   "current_step"
    t.datetime "closing_date"
    t.decimal  "closing_proceeds",                                        precision: 15, scale: 2
    t.decimal  "cap_rate"
    t.boolean  "is_selected",                                                                      default: false
    t.boolean  "sale_inspection_lease_tasks_estoppel",                                             default: false
    t.boolean  "sale_inspection_lease_tasks_rofr",                                                 default: false
    t.boolean  "purchase_inspection_lease_tasks_abstract",                                         default: false
    t.boolean  "purchase_inspection_lease_tasks_conference_with_clients",                          default: false
    t.index ["property_id", "transaction_id"], name: "index_transaction_properties_on_property_id_and_transaction_id", unique: true, using: :btree
    t.index ["property_id"], name: "index_transaction_properties_on_property_id", using: :btree
    t.index ["transaction_id"], name: "index_transaction_properties_on_transaction_id", using: :btree
  end

  create_table "transaction_property_offers", force: :cascade do |t|
    t.string   "offer_name"
    t.integer  "transaction_property_id"
    t.boolean  "is_accepted"
    t.integer  "accepted_counteroffer_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "relinquishing_purchaser_contact_id"
  end

  create_table "transaction_status", force: :cascade do |t|
    t.integer  "type_is"
    t.integer  "transaction_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_terms", force: :cascade do |t|
    t.decimal  "purchase_price",                              precision: 15, scale: 2
    t.integer  "cap_rate"
    t.date     "psa_date"
    t.date     "first_deposit_date_due"
    t.decimal  "first_deposit",                               precision: 15, scale: 2
    t.integer  "inspection_period_days"
    t.text     "end_of_inspection_period_note"
    t.boolean  "second_deposit"
    t.decimal  "second_deposit_amount",                       precision: 15, scale: 2
    t.date     "closing_date"
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "second_deposit_date_due"
    t.decimal  "current_annual_rent",                         precision: 15, scale: 2
    t.text     "closing_date_note"
    t.boolean  "m_date_select",                                                        default: false
    t.boolean  "m_first_deposit_date_due",                                             default: false
    t.boolean  "m_closing_date",                                                       default: false
    t.boolean  "m_psa_date",                                                           default: false
    t.boolean  "m_second_deposit_date_due",                                            default: false
    t.integer  "transaction_property_id"
    t.integer  "first_deposit_days_after_psa"
    t.integer  "second_deposit_days_after_inspection_period"
    t.integer  "closing_days_after_inspection_period"
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "key",                                  limit: 20
    t.date     "start_date"
    t.integer  "client_id"
    t.integer  "type_is"
    t.boolean  "purchaser_person_is",                             default: false
    t.integer  "property_id"
    t.float    "sale_price"
    t.datetime "deleted_at"
    t.integer  "transaction_main_id"
    t.string   "relinquishing_purchaser_first_name"
    t.string   "relinquishing_purchaser_last_name"
    t.boolean  "relinquishing_purchaser_honorific_is",            default: false
    t.string   "relinquishing_purchaser_honorific"
    t.integer  "relinquishing_purchaser_contact_id"
    t.string   "relinquishing_seller_first_name"
    t.string   "relinquishing_seller_last_name"
    t.boolean  "relinquishing_seller_honorific_is",               default: false
    t.string   "relinquishing_seller_honorific"
    t.integer  "relinquishing_seller_entity_id"
    t.string   "replacement_purchaser_first_name"
    t.string   "replacement_purchaser_last_name"
    t.boolean  "replacement_purchaser_honorific_is",              default: false
    t.string   "replacement_purchaser_honorific"
    t.integer  "replacement_purchaser_entity_id"
    t.string   "replacement_seller_first_name"
    t.string   "replacement_seller_last_name"
    t.boolean  "replacement_seller_honorific_is",                 default: false
    t.string   "replacement_seller_honorific"
    t.integer  "replacement_seller_contact_id"
    t.integer  "is_purchase"
    t.boolean  "seller_person_is",                                default: false
    t.date     "purchase_only_closing_date"
    t.float    "purchase_only_qi_funds"
    t.boolean  "m_purchase_only_closing_date",                    default: false
    t.index ["deleted_at"], name: "index_transactions_on_deleted_at", using: :btree
    t.index ["key"], name: "index_transactions_on_key", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                  default: "",                    null: false
    t.string   "encrypted_password",                     default: "",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          default: 0,                     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                  default: false
    t.string   "provider"
    t.string   "uid"
    t.boolean  "default",                                default: false
    t.boolean  "just_email",                             default: false
    t.boolean  "have_alt",                               default: false
    t.boolean  "blocked",                                default: false
    t.boolean  "trash",                                  default: false
    t.boolean  "approval_msg",                           default: false
    t.boolean  "user_indexing",                          default: false
    t.boolean  "admin_indexing",                         default: true
    t.boolean  "list_view_plus",                         default: false
    t.boolean  "list_view_minus",                        default: false
    t.boolean  "list_view_toggle",                       default: true
    t.datetime "last_pull_changes",                      default: '2015-05-29 12:39:41'
    t.boolean  "ccdf_upload_enabled",                    default: false
    t.string   "allowed_ccdf_file_mime_type"
    t.boolean  "deleted",                                default: false
    t.string   "key",                         limit: 20
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "enabled",                                default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["key"], name: "index_users_on_key", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_unregistered", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",        limit: 20
    t.index ["email"], name: "index_users_unregistered_on_email", using: :btree
  end

  create_table "wired_instructions", force: :cascade do |t|
    t.integer  "qualified_intermediary_id"
    t.text     "bank"
    t.string   "aba_no"
    t.string   "credit_to"
    t.string   "account_number"
    t.string   "reference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "rent_tables", "properties"
end
