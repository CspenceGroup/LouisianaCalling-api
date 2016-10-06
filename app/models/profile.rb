class Profile < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_by_name, use: :slugged

  serialize :interests, Array
  serialize :skills, Array

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :job_title, presence: true
  validates :region, presence: true
  validates :description, presence: true
  validates :interests, presence: true
  validates :skills, presence: true
  validates :demand, presence: true
  validates :cluster, presence: true
  validates :salary, presence: true
  validates :education, presence: true
  validates :video, presence: true
  validates :image_large, presence: true
  validates :image_medium, presence: true
  validates :image_small, presence: true

  scope :find_by_full_name, lambda { |full_name|
    full_name = full_name.split(' ')
    where('first_name = ? AND last_name = ?', full_name.first, full_name.last)
  }

  private

  def full_name
    "#{first_name} #{last_name}"
  end

  # Defaults a slug with name
  def slug_by_name
    "#{full_name.gsub(/[^a-zA-Z0-9]/, '-')}-#{id}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || first_name_changed? || last_name_changed?
  end
end
