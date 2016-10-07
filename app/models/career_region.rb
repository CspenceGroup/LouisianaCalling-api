class CareerRegion < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_title, use: [:slugged, :finders]

  private

  # Defaults a slug with title
  def slug_by_title
    "#{title.gsub(/[^a-zA-Z0-9]/, '-')}-#{id}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def self.import_from_csv(csv)
    CareerRegion.transaction do
      CareerRegion.delete_all

      csv.each do |row|
        careerRegion = CareerRegion.new
        careerRegion[:title] = row[0].strip
        # careerRegion[:slug] = row[0].parameterize
        careerRegion[:region] = row[1].strip
        careerRegion[:salary_min] = row[2].strip
        careerRegion[:salary_max] = row[3].strip
        careerRegion[:education] = row[4].strip

        if row[5]
          raise "Wrong file"
        end

        careerRegion.save!
      end
    end
  end
end
