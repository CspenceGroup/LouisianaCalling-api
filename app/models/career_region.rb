class CareerRegion < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_title, use: [:slugged, :finders]

  has_one :region
  has_one :career

  has_many :education

  def self.import_from_csv(csv)
    CareerRegion.transaction do
      CareerRegion.delete_all

      csv.each do |row|
        career_region = CareerRegion.new
        career_region[:title] = row[0].strip
        # career_region[:slug] = row[0].parameterize
        career_region[:region] = row[1].strip
        career_region[:salary_min] = row[2].strip
        career_region[:salary_max] = row[3].strip
        career_region[:education] = row[4].strip

        raise 'Wrong file' if row[5].present?

        career_region.save!
      end
    end
  end

  private

  # Defaults a slug with title
  def slug_by_title
    "#{title.gsub(/[^a-zA-Z0-9]/, '-')}-#{id}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
