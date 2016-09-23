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

ActiveRecord::Schema.define(version: 20160923093328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "careers", force: :cascade do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "region"
    t.string   "education"
    t.text     "about_job"
    t.text     "what_will_do"
    t.string   "related_career_by_skill"
    t.string   "related_career_by_interest"
    t.string   "profile_name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "photo_large"
    t.string   "photo_medium"
    t.string   "photo_small"
    t.text     "industries"
    t.text     "interests"
    t.text     "skills"
    t.integer  "salary_min"
    t.integer  "salary_max"
    t.float    "demand"
    t.text     "regions_high_demand"
  end

  create_table "clusters", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interests", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.string   "region"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "email"
    t.text     "description"
    t.text     "interests"
    t.text     "skills"
    t.string   "demand"
    t.string   "cluster"
    t.string   "salary"
    t.string   "education"
    t.string   "video"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "image_large"
    t.string   "image_medium"
    t.string   "image_small"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "top_jobs", force: :cascade do |t|
    t.string   "region"
    t.string   "job_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "videos", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.string   "main_title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
