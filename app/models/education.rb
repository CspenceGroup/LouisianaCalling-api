class Education < ActiveRecord::Base
  has_many :careers
  has_many :profiles

  validates :name, presence: true

  def self.import_from_csv(csv)
    Education.transaction do
      Education.delete_all

      csv.each do |row|
        education = Education.new
        education[:name] = row[0].strip

        raise 'Wrong file' if row[1].present?

        education.save!
      end
    end
  end
end
