class TopJob < ActiveRecord::Base
  belongs_to :region
  belongs_to :career

  validates :region, presence: true

  def self.import_from_csv(csv)
    TopJob.transaction do
      TopJob.delete_all

      csv.each do |row|
        top_jobs = TopJob.new

        region = Region.filter_by_name(row[0].strip).first
        top_jobs[:region_id] = region.id if region.present?

        career = Career.filter_by_title(row[1].strip).first
        top_jobs[:career_id] = career.id if career.present?

        raise 'Wrong file' if row[2]

        top_jobs.save!
      end
    end
  end
end
