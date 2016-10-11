class Region < ActiveRecord::Base
  belongs_to :career

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
