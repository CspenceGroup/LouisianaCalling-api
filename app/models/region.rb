class Region < ActiveRecord::Base
  has_many :careers
  has_many :profiles

  has_many :top_jobs

  scope :filter_by_name, lambda { |name|
    where('name like ?', name)
  }

  def self.import_from_csv(csv)
    Region.transaction do
      Region.delete_all
      csv.each do |row|
        next if Region.exists?(name: row[0].strip)

        region = Region.new
        region[:name] = row[0].strip
        region.save!
      end
    end
  end
end
