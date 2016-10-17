class Program < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_title, use: :slugged

  has_many :program_clusters, dependent: :destroy
  has_many :industries, through: :program_clusters, source: :cluster

  has_many :program_careers, dependent: :destroy
  has_many :careers, through: :program_careers, source: :career

  belongs_to :education
  belongs_to :region

  validates_inclusion_of :duration, in: Constants::PROGRAM_DURATIONS
  validates_inclusion_of :time_of_day, in: Constants::TIME_OF_DAY
  validates_inclusion_of :hours_per_weeks, in: Constants::HOURS_PER_WEEK

  scope :filter_by_tuition, lambda { |tuition_min, tuition_max|
    where('tuition_max <= ? AND tuition_min >= ?', tuition_max, tuition_min)
  }

  scope :filter_by_title, lambda { |title|
    query = ['LOWER(title) like ? ']
    query.push('LOWER(institution_name) like ? ')
    title = "%#{title.downcase}%"
    where(query.join(' OR '), title, title)
  }

  scope :filter_by_regions, lambda { |regions|
    where('region_id IN (?)', regions)
  }

  scope :filter_by_educations, lambda { |educations|
    where('education_id IN (?)', educations)
  }

  scope :with_clusters, lambda {
    joins(:program_clusters).distinct
  }

  scope :filter_by_industries, lambda { |industries|
    with_clusters.where('program_clusters.cluster IN (?)', industries)
  }

  def self.import_from_csv(csv)
    Program.transaction do
      Program.delete_all

      csv.each_with_index do |row|
        raise 'Wrong file' if row[20].present?

        program = Program.new
        program[:title] = row[0].strip

        region = Region.find_by_name(row[1].strip)
        program[:region_id] = region.id if region.present?

        program[:traning_detail] = row[2].strip
        program[:description] = row[3].strip
        program[:duration] = row[4].strip
        program[:time_of_day] = row[5].strip
        program[:hours_per_weeks] = row[6].strip
        program[:tuition_min] = row[7].strip
        program[:tuition_max] = row[8].strip

        education = Education.find_by_name(row[9].strip)
        program[:education_id] = education.id if education.present?

        program[:institution_name] = row[10].strip
        program[:phone] = row[11].strip
        program[:address] = row[12].strip

        if row[13].present?
          location = row[13].split(',').map(&:strip)
          program[:lat] = location[0]
          program[:lng] = location[1]
        end

        program.save!

        (14..17).each do |i|
          create_program_cluster(row[i].strip, program) if row[i].present?
        end

        program[:cover_photo] = row[18].strip
        if row[19].present?
          create_program_careers(row[19].split(';').map(&:strip), program)
        end
      end
    end
  end

  def self.create_program_careers(careers, program)
    careers.each do |career_name|
      career = Career.find_by_title(career_name)

      ProgramCareer.create(
        program_id: program.id,
        career_id: career.present? ? career.id : nil
      )
    end
  end

  def self.create_program_cluster(cluster_name, program)
    cluster = Cluster.find_by_name(cluster_name)

    ProgramCluster.create(
      program_id: program.id,
      cluster_id: cluster.present? ? cluster.id : nil
    )
  end

  def to_s
    title
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
