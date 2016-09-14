class TopJob < ApplicationRecord
  validates :region, presence: true
  validates :job_title, presence: true
end
