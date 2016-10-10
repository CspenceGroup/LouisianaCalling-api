class TopJob < ActiveRecord::Base
  has_one :region
  has_one :career

  validates :region, presence: true
  # validates :job_title, presence: true

  def self.import_from_csv(csv)
    TopJob.transaction do
      TopJob.delete_all

      csv.each do |row|
        top_jobs = TopJob.new
        top_jobs[:region] = row[0].strip
        top_jobs[:job_title] = row[1].strip

        raise 'Wrong file' if row[2]

        top_jobs.save!
      end
    end
  end
end
