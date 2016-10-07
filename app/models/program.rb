class Program < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_by_title, use: :slugged

  serialize :industries, Array
  serialize :interests, Array
  serialize :career, Array

  validates_inclusion_of :duration, :in => ["8 Weeks", "3 Months", "6 Months", "1 Year or 2 Semesters", "2 Years or 4 Semesters", "2 Years+", ""]
  validates_inclusion_of :time_of_day, :in => ["Day", "Night", "Both", ""]
  validates_inclusion_of :hours_per_weeks, :in => ["3 - 10 Hours", "11 - 20 Hours", "21 - 30 Hours", "31 - 40 Hours", ""]
  validates_inclusion_of :financial_help, :in => ["Scholarship", "Financial Aid/Grant", ""]
  validates_inclusion_of :education, :in => ["High School Diploma/Hi-SET", "Certificate or Credential", "Associate's Degree", "Bachelor's Degree", "Master's Degree", ""]

  scope :filter_by_tuition, lambda { |tuition_min, tuition_max|
    where('tuition_max <= ? AND tuition_min >= ?', tuition_max, tuition_min)
  }

  scope :filter_by_title, lambda { |title|
    query = ["LOWER(title) like '%?%'"]
    query.push("LOWER(institution_name) like '%?%'")
    query.push("LOWER(career) like '%?%')")

    where(query.json(' OR '), title.downcase)
  }

  scope :filter_by_region, lambda { |region|
    where('region like ?', region)
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
