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

  before_destroy :delete_top_job

  # Sorting by alphabetical
  scope :alphabetical, lambda {
    order(:name)
  }

  scope :filter_by_names, lambda { |names|
    where('LOWER(name) IN (?)', names)
  }

  scope :filter_names_not_exist, lambda { |names|
    where('name NOT IN (?)', names)
  }

  # Find region by name and raise error when not found
  def self.find_region(region_name)
    region = Region.find_by_name(region_name)
    unless region.present?
      raise "Do not found with region: '#{region_name}'.
        Please make sure import Region before."
    end

    region
  end

  # Remove all regions do not exists in TSV file import
  def self.remove(names)
    regions = Region.filter_names_not_exist(names)

    regions.delete_all if regions.present?
  end

  def self.import_from_csv(csv)
    Region.transaction do
      # Region.delete_all

      # Create region
      csv.each do |row|
        name_str = row[0].strip
        next if Region.exists?(name: name_str)

        region = Region.new
        region[:name] = name_str
        region.save!
      end

      # Remove all region do not exists in tsv file
      names = csv.map { |column| column[0].strip }.uniq
      Region.remove(names)
    end
  end

  def to_s
    name
  end

  private

  def delete_top_job
    TopJob.where(region_id: id).delete_all
  end
end
