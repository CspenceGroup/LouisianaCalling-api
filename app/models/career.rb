class Career < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_by_title, use: :slugged

  serialize :regions_high_demand, Array
  serialize :interests, Array
  serialize :skills, Array
  serialize :industries, Array
  serialize :related_career_by_skill, Array
  serialize :related_career_by_interest, Array
  serialize :region, Array

  validates :title, presence: true
  validates :education, presence: true
  validates :about_job, presence: true
  validates :what_will_do, presence: true
  validates :related_career_by_skill, presence: true
  validates :related_career_by_interest, presence: true
  # validates :profile_name, presence: true
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

  scope :filter_by_title, lambda { |titles|
    where('title IN (?)', titles)
  }

  scope :filter_by_title_and_region, lambda { |title, region|
    where('LOWER(title) like ? AND region like ?', title.downcase, region)
  }

  scope :filter_by_salary, lambda { |salary_min, salary_max|
    where('salary_max <= ? AND salary_min >= ?', salary_max, salary_min)
  }

  private

  # Defaults a slug with title
  def slug_by_title
    "#{title.gsub(/[^a-zA-Z0-9]/, '-')}-#{id}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
