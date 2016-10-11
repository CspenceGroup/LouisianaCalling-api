class Interest < ActiveRecord::Base

  has_many :career_interests, dependent: :destroy
  has_many :careers, through: :career_interests

  has_many :profile

  validates :name, presence: true
  validates :url, presence: true

  def self.import_from_csv(csv)
    Interest.transaction do
      Interest.delete_all

      csv.each do |row|
        interest = Interest.new
        interest[:name] = row[0].strip
        interest[:url] = row[1].strip

        raise 'Wrong file' if row[2].present?

        interest.save!
      end
    end
  end
end
