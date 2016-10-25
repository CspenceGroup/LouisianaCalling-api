# == Schema Information
#
# Table name: educations
#
#  id             :integer          not null, primary key
#  name           :string
#  url            :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Interest < ActiveRecord::Base
  has_many :career_interests, dependent: :destroy
  has_many :careers, through: :career_interests

  has_many :profile_interests, dependent: :destroy
  has_many :profiles, through: :profile_interests

  validates :name, presence: true
  validates :url, presence: true

  validates_uniqueness_of :name

  def self.import_from_csv(csv)
    Interest.transaction do
      Interest.delete_all

      csv.each do |row|
        name_str = row[0].strip
        next if Interest.exists?(name: name_str)

        interest = Interest.new
        interest[:name] = name_str
        interest[:url] = row[1].strip

        interest.save!
      end
    end
  end

  def to_s
    name
  end
end
