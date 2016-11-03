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
        params = {
          title: row[0].strip,
          url: row[1].strip,
          description: row[3].strip
        }

        if row[2].strip.present?
          profile = Profile.find_by_full_name(row[2].strip).first
          params[:profile_id] = profile.id if profile.present?
        end

        if Video.exists?(title: params[:title])
          video = Video.find_by_title(params[:title])
          video.update_attributes(params)
        else
          Video.create(params)
        end
      end
    end
  end
end
