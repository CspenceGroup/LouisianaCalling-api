# == Schema Information
#
# Table name: educations
#
#  id             :integer          not null, primary key
#  name           :string
#  url_selected   :string
#  url            :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Education < ActiveRecord::Base
  has_many :careers
  has_many :profiles

  validates :name, presence: true
  validates :url, presence: true
  validates :url_selected, presence: true
  validates_uniqueness_of :name

  def self.find_or_create(education_name)
    education = Education.find_by_name(education_name)

    # Adding new education
    education = Education.create(name: education_name) unless education.present?

    education
  end

  def self.import_from_csv(csv)
    Education.transaction do
      Education.delete_all

      csv.each do |row|
        name_str = row[0].strip
        next if Education.exists?(name: name_str)

        education = Education.new
        education[:name] = name_str
        education[:url] = row[1].strip
        education[:url_selected] = row[2].strip

        education.save!
      end
    end
  end

  def to_s
    name
  end
end
