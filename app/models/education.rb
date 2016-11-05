# == Schema Information
#
# Table name: educations
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Education < ActiveRecord::Base
  has_many :careers
  has_many :profiles

  validates :name, presence: true
  validates_uniqueness_of :name

  scope :filter_names_not_exist, lambda { |names|
    where('name NOT IN (?)', names)
  }

  # Sorting by alphabetical
  scope :alphabetical, lambda {
    order(:name)
  }

  # Remove all educations do not exists in TSV file import
  def self.remove(csv_file)
    names = csv_file.map { |row| row[0].strip }.uniq
    educations = Education.filter_names_not_exist(names)

    educations.delete_all if educations.present?
  end

  def self.find_education(education_name)
    education = Education.find_by_name(education_name)

    unless education.present?
      raise "Do not found with education: '#{education_name}'.
        Please make sure import Education before."
    end

    education
  end

  def self.update_education(params)
    education = Education.find_by_name(params[:name])

    raise "Do not found with education: '#{params[:name]}'." unless education.present?

    education.update_attributes(params)
  end

  def self.import_from_csv(csv)
    Education.transaction do
      # Education.delete_all

      csv.each do |row|
        name_str = row[0].strip
        next if Education.exists?(name: name_str)

        education = Education.new
        education[:name] = name_str
        education.save!
      end

      # Remove all Education do not exists in tsv file
      Education.remove(csv)
    end
  end

  def to_s
    name
  end
end
