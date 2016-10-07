class Interest < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true

  def self.import_from_csv(csv)
    Interest.transaction do
      Interest.delete_all

      csv.each do |row|
        interest = Interest.new
        interest[:name] = row[0].strip
        interest[:url] = row[1].strip

        if row[2]
          raise "Wrong file"
        end

        interest.save!
      end
    end
  end
end
