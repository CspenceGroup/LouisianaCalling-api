class Program < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_title, use: :slugged

  serialize :industries, Array
  serialize :interests, Array
  serialize :career, Array

  validates_inclusion_of :duration, :in => ["8 Weeks", "3 Months", "6 Months", "1 Year or 2 Semesters", "2 Years or 4 Semesters", "2 Years+", ""]
  validates_inclusion_of :time_of_day, :in => ["Day", "Night", "Both", ""]
  validates_inclusion_of :hours_per_weeks, :in => ["3 - 10 Hours", "11 - 20 Hours", "21 - 30 Hours", "31 - 40 Hours", ""]
  validates_inclusion_of :education, :in => ["High School Diploma/Hi-SET", "Certificate or Credential", "Associate's Degree", "Bachelor's Degree", "Master's Degree", ""]

  scope :filter_by_tuition, lambda { |tuition_min, tuition_max|
    where('tuition_max <= ? AND tuition_min >= ?', tuition_max, tuition_min)
  }

  scope :filter_by_title, lambda { |title|
    query = ["LOWER(title) like ? "]
    query.push("LOWER(institution_name) like ? ")
    query.push("LOWER(career) like ? ")
    title = "%#{title.downcase}%"
    where(query.join(' OR '), title, title, title)
  }

  scope :filter_by_region, lambda { |region|
    where('region like ?', region)
  }

  def self.import_from_csv(csv)
    Program.transaction do
      Program.delete_all

      csv.each_with_index do |row, index|
        program = Program.new
        program[:title] = row[0].strip
        # program[:id] = index + 1
        # program[:slug] = row[0].parameterize + '-' + (index + 1).to_s
        program[:region] = row[1].strip
        program[:traning_detail] = row[2].strip
        program[:description] = row[3].strip
        program[:duration] = row[4].strip
        program[:time_of_day] = row[5].strip
        program[:hours_per_weeks] = row[6].strip
        program[:tuition_min] = row[7].strip
        program[:tuition_max] = row[8].strip
        program[:education] = row[9].strip
        program[:institution_name] = row[10].strip
        program[:phone] = row[11].strip
        program[:address] = row[12].strip

        location = row[13].split(',').map{ |s| s.strip }
        program[:lat] = location[0]
        program[:lng] = location[1]

        program[:industries] = []

        for i in 14..17
          if (row[i] != "" && row[i] != nil) then
            program[:industries] << row[i].strip
          end
        end

        program[:cover_photo] = row[18].strip
        program[:career] = row[19].split(';').map{ |s| s.strip }

        if row[20]
          raise "Wrong file"
        end

        program.save!
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
