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
        region = Region.find_region(row[0].strip)
        career = Career.find_career(row[1].strip)

        params = {}
        params[:region_id] = region.id if region.present?
        params[:career_id] = career.id if career.present?

        top_job = TopJob.where(
          career_id: career.id,
          region_id: region.id
        ).first

        next if top_job.present?

        TopJob.create(params)
      end
    end
  end
end
