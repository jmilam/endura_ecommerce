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

ActiveRecord::Schema.define(version: 20170426131027) do

  create_table "catalog_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.date     "deadline"
    t.string   "sales_rep"
    t.string   "tsm"
    t.string   "company_name"
    t.string   "company_contact"
    t.string   "email"
    t.string   "phone_number"
    t.string   "ship_address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "produced_by"
    t.integer  "page_count"
    t.string   "endura_intro"
    t.string   "z_cap_sill"
    t.string   "trillenium_multi_point"
    t.string   "multi_point_astragal"
    t.string   "ultimate_astragal"
    t.string   "flip_lever_astragal"
    t.string   "framesaver"
    t.string   "weathersealing"
    t.string   "other"
    t.text     "other_desc",             limit: 65535
    t.string   "file_1"
    t.string   "file_2"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sales_rep_id"
    t.string   "company_name"
    t.string   "contact_email"
    t.string   "phone_number"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "company_contact", limit: 65535
    t.index ["sales_rep_id"], name: "index_customers_on_sales_rep_id", using: :btree
  end

  create_table "funds_banks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "customer_id"
    t.float    "allocated_amt", limit: 24, default: 0.0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "current_bal",              default: 0
    t.index ["customer_id"], name: "index_funds_banks_on_customer_id", using: :btree
  end

  create_table "image_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.date     "deadline"
    t.string   "sales_rep"
    t.string   "tsm"
    t.string   "company_name"
    t.string   "company_contact"
    t.string   "email"
    t.string   "phone_number"
    t.string   "request_purpose"
    t.text     "other_entry",         limit: 65535
    t.integer  "total_number_images"
    t.text     "images_needed",       limit: 65535
    t.string   "file_format"
    t.binary   "file_1",              limit: 65535
    t.binary   "file_2",              limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.float    "price",      limit: 24
    t.string   "group"
    t.string   "file_name"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "sub_group"
  end

  create_table "order_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.string   "item_type"
    t.integer  "reference_id"
    t.integer  "quantity"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.float    "item_total",   limit: 24, default: 0.0
    t.string   "note"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "current_order",                 default: false
    t.boolean  "order_complete",                default: false
    t.date     "deadline"
    t.string   "deadline_reason"
    t.text     "payment_method",  limit: 65535
    t.integer  "customer_id"
    t.text     "order_reason",    limit: 65535
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.boolean  "accepted"
    t.string   "email"
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "name",       limit: 65535
    t.float    "price",      limit: 24
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "group",      limit: 65535
    t.string   "file_name"
  end

  create_table "sales_reps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tsm_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
    t.index ["tsm_id"], name: "index_sales_reps_on_tsm_id", using: :btree
  end

  create_table "tradeshow_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "show_name"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "booth_num"
    t.string   "booth_dimensions"
    t.string   "show_size"
    t.string   "target_market"
    t.boolean  "z_cap_sill",                                   default: false
    t.boolean  "ada_sills",                                    default: false
    t.boolean  "zai_sills",                                    default: false
    t.boolean  "trilennium_multi_point_locking",               default: false
    t.boolean  "multi_point_astragal",                         default: false
    t.boolean  "ultimate_astragal",                            default: false
    t.boolean  "ultimate_flip_lever_astragal",                 default: false
    t.boolean  "framesaver",                                   default: false
    t.boolean  "weathersealing",                               default: false
    t.integer  "number_of_attendees",                          default: 0
    t.boolean  "registration_assistance",                      default: false
    t.boolean  "credit_issued",                                default: false
    t.string   "attendee_list"
    t.string   "credit_documentation"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.text     "note",                           limit: 65535
  end

  create_table "tsms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                                default: "",    null: false
    t.string   "encrypted_password",                   default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.text     "name",                   limit: 65535
    t.boolean  "admin",                                default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
