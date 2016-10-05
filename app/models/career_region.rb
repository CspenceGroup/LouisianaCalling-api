class CareerRegion < ApplicationRecord
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
end
