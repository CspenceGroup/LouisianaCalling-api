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

  before_destroy :delete_relationships

  scope :recent, -> { order(created_at: :desc) }

  scope :with_careers, lambda {
    joins(:careers)
  }

  scope :filter_by_tuition, lambda { |tuition_min, tuition_max|
    where.not('tuition_max < ? OR tuition_min > ?', tuition_min, tuition_max)
  }

  scope :filter_by_title, lambda { |title|
    query = ['LOWER(programs.title) like ? ']
    query.push('LOWER(careers.title) like ? ')
    query.push('LOWER(programs.institution_name) like ? ')
    title = "%#{title.downcase}%"
    with_careers.where(query.join(' OR '), title, title, title)
  }

  scope :filter_titles_not_exist, lambda { |titles|
    where('title NOT IN (?)', titles)
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
    with_clusters.where('program_clusters.cluster_id IN (?)', industries)
  }

  # Remove all programs do not exists in TSV file import
  def self.remove_programs(csv_file)
    titles = csv_file.map { |row| row[0].strip }.uniq
    programs = Program.filter_titles_not_exist(titles)

    programs.delete_all if programs.present?
  end

  def self.import_from_csv(csv)
    Program.transaction do
      csv.each_with_index do |row|
        region = Region.find_region(row[1].strip)
        education = Education.find_education(row[9].strip)

        params = {
          title: row[0].strip
        }

        params[:region_id] = region.id if region.present?
        params[:traning_detail] = row[2].strip
        params[:description] = row[3].strip
        params[:duration] = row[4].strip
        params[:time_of_day] = row[5].strip
        params[:hours_per_weeks] = row[6].strip
        params[:tuition_min] = row[7].strip
        params[:tuition_max] = row[8].strip
        params[:education_id] = education.id if education.present?
        params[:institution_name] = row[10].strip
        params[:phone] = row[11].strip
        params[:address] = row[12].strip

        if row[13].present?
          location = row[13].split(',').map(&:strip)
          params[:lat] = location[0]
          params[:lng] = location[1]
        end

        params[:cover_photo] = row[18].strip

        program =
          if Program.exists?(title: params[:title])
            program = Program.find_by_title(params[:title])
            program.update_attributes(params)
            program.delete_relationships
            program
          else
            Program.create(params)
          end

        (14..17).each do |i|
          create_program_cluster(row[i].strip, program) if row[i].present?
        end

        if row[19].present?
          create_program_careers(row[19].split(';').map(&:strip), program)
        end
      end

      # Remove all programs do not exists in TSV file import
      Program.remove_programs(csv)
    end
  end

  def self.create_program_careers(careers, program)
    careers.each do |career_name|
      career = Career.find_career(career_name)

      next if ProgramCareer.exists?(
        program_id: program.id,
        career_id: career.id
      )

      ProgramCareer.create(
        program_id: program.id,
        career_id: career.id
      )
    end
  end

  def self.create_program_cluster(cluster_name, program)
    cluster = Cluster.find_or_create(cluster_name)

    return if ProgramCluster.exists?(
      program_id: program.id,
      cluster_id: cluster.id
    )

    ProgramCluster.create(
      program_id: program.id,
      cluster_id: cluster.id
    )
  end

  def delete_relationships
    ProgramCareer.where(program_id: id).delete_all
    ProgramCluster.where(program_id: id).delete_all
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
