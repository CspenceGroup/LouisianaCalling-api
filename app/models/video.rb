# == Schema Information
#
# Table name: videos
#
#  id             :integer          not null, primary key
#  profile_id     :integer
#  title          :string
#  url            :string
#  description    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#

class Video < ActiveRecord::Base
  belongs_to :profile

  validates :title, presence: true
  validates :url, presence: true

  def self.import_from_csv(csv)
    Video.transaction do
      Video.delete_all

      csv.each do |row|
        raise 'Wrong file' if row[4].present?

        video = Video.new
        video[:title] = row[0].strip
        video[:url] = row[1].strip

        if row[2].strip.present?
          profile = Profile.find_by_full_name(row[2].strip).first
          video[:profile_id] = profile.id if profile.present?
        end
        video[:description] = row[3].strip

        video.save!
      end
    end
  end
end
