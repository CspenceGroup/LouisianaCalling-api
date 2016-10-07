class Video < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true

  def self.import_from_csv(csv)
    Video.transaction do
      Video.delete_all

      csv.each do |row|
        video = Video.new
        video[:title] = row[0].strip
        video[:url] = row[1].strip
        video[:profile_name] = row[2].strip
        video[:description] = row[3].strip

        if row[4]
          raise "Wrong file"
        end

        video.save!
      end
    end
  end
end
