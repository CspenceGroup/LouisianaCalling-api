# == Schema Information
#
# Table name: regions
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Region < ActiveRecord::Base
  has_many :careers
  has_many :profiles

  has_many :top_jobs

  validates :name, presence: true
  validates_uniqueness_of :name

  scope :filter_by_name, lambda { |name|
    where('name like ?', name)
  }

  def self.import_from_csv(csv)
    Region.transaction do
      Region.delete_all

      csv.each do |row|

        name_str = row[0].strip
        next if Region.exists?(name: name_str)

        region = Region.new
        region[:name] = name_str
        region.save!
      end
    end
  end

  def to_s
    name
  end
end
