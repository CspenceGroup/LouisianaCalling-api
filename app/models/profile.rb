class Profile < ApplicationRecord
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

end
