# == Schema Information
#
# Table name: top_jobs
#
#  id             :integer          not null, primary key
#  career_id     :integer
#  region_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#

class TopJob < ActiveRecord::Base
  belongs_to :region
  belongs_to :career

  validates :region, presence: true
  validates :career, presence: true

  scope :valid, -> { where('career_id IS NOT NULL') }

  def self.import_from_csv(csv)
    TopJob.transaction do
      TopJob.delete_all

      csv.each do |row|
        raise 'Wrong file' if row[2].present?

        top_jobs = TopJob.new

        region = Region.find_by_name(row[0].strip)
        top_jobs[:region_id] = region.id if region.present?

        career = Career.find_by_title(row[1].strip)

        top_jobs[:career_id] = career.id if career.present?

        top_jobs.save!
      end
    end
  end
end
