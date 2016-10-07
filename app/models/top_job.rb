class TopJob < ActiveRecord::Base
  validates :region, presence: true
  validates :job_title, presence: true

  def self.import_from_csv(csv)
    TopJob.transaction do
      TopJob.delete_all
      csv.each do |row|
        topJobs = TopJob.new
        topJobs[:region] = row[0].strip
        topJobs[:job_title] = row[1].strip

        if row[2]
          raise "Wrong file"
        end

        topJobs.save!
      end
    end
  end

end
