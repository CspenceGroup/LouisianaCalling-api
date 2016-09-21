class Career < ApplicationRecord
  serialize :regions_high_demand, Array
  serialize :interests, Array
  serialize :skills, Array
  serialize :industries, Array
  serialize :related_career_by_skill, Array
  serialize :related_career_by_interest, Array

  validates :title, presence: true
  validates :region, presence: true
  validates :education, presence: true
  validates :about_job, presence: true
  validates :what_will_do, presence: true
  validates :related_career_by_skill, presence: true
  validates :related_career_by_interest, presence: true
  validates :profile_name, presence: true
  validates :photo_large, presence: true
  validates :photo_medium, presence: true
  validates :photo_small, presence: true
  validates :industries, presence: true
  validates :interests, presence: true
  validates :skills, presence: true
  validates :salary_min, presence: true
  validates :salary_max, presence: true
  validates :demand, presence: true
  validates :regions_high_demand, presence: true
end
