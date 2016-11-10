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

ActiveRecord::Schema.define(version: 20161104091736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "career_clusters", force: :cascade do |t|
    t.integer "career_id"
    t.integer "cluster_id"
    t.index ["career_id"], name: "index_career_clusters_on_career_id", using: :btree
    t.index ["cluster_id"], name: "index_career_clusters_on_cluster_id", using: :btree
  end

  create_table "career_educations", force: :cascade do |t|
    t.integer "career_id"
    t.integer "education_id"
    t.index ["career_id"], name: "index_career_educations_on_career_id", using: :btree
    t.index ["education_id"], name: "index_career_educations_on_education_id", using: :btree
  end

  create_table "career_interests", force: :cascade do |t|
    t.integer "career_id"
    t.integer "interest_id"
    t.index ["career_id"], name: "index_career_interests_on_career_id", using: :btree
    t.index ["interest_id"], name: "index_career_interests_on_interest_id", using: :btree
  end

  create_table "career_interestships", force: :cascade do |t|
    t.integer "career_id"
    t.integer "career_related_id"
    t.index ["career_id"], name: "index_career_interestships_on_career_id", using: :btree
    t.index ["career_related_id"], name: "index_career_interestships_on_career_related_id", using: :btree
  end

  create_table "career_region_educations", force: :cascade do |t|
    t.integer "career_region_id"
    t.integer "education_id"
    t.index ["career_region_id"], name: "index_career_region_educations_on_career_region_id", using: :btree
    t.index ["education_id"], name: "index_career_region_educations_on_education_id", using: :btree
  end

  create_table "career_region_high_demands", force: :cascade do |t|
    t.integer "career_id"
    t.integer "region_id"
    t.index ["career_id"], name: "index_career_region_high_demands_on_career_id", using: :btree
    t.index ["region_id"], name: "index_career_region_high_demands_on_region_id", using: :btree
  end

  create_table "career_regions", force: :cascade do |t|
    t.integer  "salary_min"
    t.integer  "salary_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "career_id"
    t.integer  "region_id"
    t.integer  "demand"
    t.index ["career_id"], name: "index_career_regions_on_career_id", using: :btree
    t.index ["region_id"], name: "index_career_regions_on_region_id", using: :btree
  end

  create_table "career_skills", force: :cascade do |t|
    t.integer "career_id"
    t.integer "skill_id"
    t.index ["career_id"], name: "index_career_skills_on_career_id", using: :btree
    t.index ["skill_id"], name: "index_career_skills_on_skill_id", using: :btree
  end

  create_table "career_skillships", force: :cascade do |t|
    t.integer "career_id"
    t.integer "career_related_id"
    t.index ["career_id"], name: "index_career_skillships_on_career_id", using: :btree
    t.index ["career_related_id"], name: "index_career_skillships_on_career_related_id", using: :btree
  end

  create_table "careers", force: :cascade do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "about_job"
    t.text     "what_will_do"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "photo_large"
    t.string   "photo_medium"
    t.integer  "salary_min"
    t.integer  "salary_max"
    t.float    "demand"
    t.integer  "top_job_id"
    t.integer  "projected_growth"
    t.integer  "numerical_order"
    t.index ["top_job_id"], name: "index_careers_on_top_job_id", using: :btree
  end

  create_table "clusters", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "interests", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "home_url"
    t.string   "gj_url"
    t.string   "gj_url_selected"
  end

  create_table "profile_careers", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "career_id"
    t.index ["career_id"], name: "index_profile_careers_on_career_id", using: :btree
    t.index ["profile_id"], name: "index_profile_careers_on_profile_id", using: :btree
  end

  create_table "profile_interests", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "interest_id"
    t.index ["interest_id"], name: "index_profile_interests_on_interest_id", using: :btree
    t.index ["profile_id"], name: "index_profile_interests_on_profile_id", using: :btree
  end

  create_table "profile_skills", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "skill_id"
    t.index ["profile_id"], name: "index_profile_skills_on_profile_id", using: :btree
    t.index ["skill_id"], name: "index_profile_skills_on_skill_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "email"
    t.text     "description"
    t.string   "demand"
    t.string   "salary"
    t.string   "video"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image_large"
    t.string   "image_medium"
    t.string   "image_small"
    t.string   "slug"
    t.integer  "region_id"
    t.integer  "cluster_id"
    t.string   "educational_institution"
    t.string   "sub_head"
    t.string   "qualification"
    t.index ["cluster_id"], name: "index_profiles_on_cluster_id", using: :btree
    t.index ["region_id"], name: "index_profiles_on_region_id", using: :btree
  end

  create_table "program_careers", force: :cascade do |t|
    t.integer "career_id"
    t.integer "program_id"
    t.index ["career_id"], name: "index_program_careers_on_career_id", using: :btree
    t.index ["program_id"], name: "index_program_careers_on_program_id", using: :btree
  end

  create_table "program_clusters", force: :cascade do |t|
    t.integer "cluster_id"
    t.integer "program_id"
    t.index ["cluster_id"], name: "index_program_clusters_on_cluster_id", using: :btree
    t.index ["program_id"], name: "index_program_clusters_on_program_id", using: :btree
  end

  create_table "programs", force: :cascade do |t|
    t.string   "title"
    t.text     "traning_detail"
    t.text     "description"
    t.string   "duration"
    t.string   "time_of_day"
    t.string   "hours_per_weeks"
    t.integer  "tuition_min"
    t.integer  "tuition_max"
    t.string   "institution_name"
    t.string   "phone"
    t.string   "address"
    t.string   "lat"
    t.string   "lng"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "slug"
    t.string   "cover_photo"
    t.integer  "region_id"
    t.integer  "education_id"
    t.index ["education_id"], name: "index_programs_on_education_id", using: :btree
    t.index ["region_id"], name: "index_programs_on_region_id", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "top_job_id"
    t.index ["top_job_id"], name: "index_regions_on_top_job_id", using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "top_jobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "career_id"
    t.integer  "region_id"
    t.index ["career_id"], name: "index_top_jobs_on_career_id", using: :btree
    t.index ["region_id"], name: "index_top_jobs_on_region_id", using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "url"
    t.string   "title"
    t.integer  "profile_id"
    t.index ["profile_id"], name: "index_videos_on_profile_id", using: :btree
  end

end
