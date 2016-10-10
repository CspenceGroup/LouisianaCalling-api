class Education < ActiveRecord::Base
  has_many :career
  has_many :career_region
  has_many :profile

  validates :name, presence: true

  def self.import_from_csv(csv)
    Education.transaction do
      Education.delete_all

      csv.each do |row|
        education = Education.new
        education[:name] = row[0].strip

        if row[1]
          raise "Wrong file"
        end

        education.save!
      end
    end
  end
end
