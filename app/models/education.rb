# == Schema Information
#
# Table name: educations
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Education < ActiveRecord::Base
  has_many :careers
  has_many :profiles

  validates :name, presence: true
  validates_uniqueness_of :name

  def self.import_from_csv(csv)
    Education.transaction do
      Education.delete_all

      csv.each do |row|
        name_str = row[0].strip
        next if Education.exists?(name: name_str)

        education = Education.new
        education[:name] = name_str

        education.save!
      end
    end
  end

  def to_s
    name
  end
end
