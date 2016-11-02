# == Schema Information
#
# Table name: educations
#
#  id                 :integer          not null, primary key
#  name               :string
#  url                :string
#  home_url           :string
#  gj_url             :string
#  gj_url_selected    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Interest < ActiveRecord::Base
  has_many :career_interests, dependent: :destroy
  has_many :careers, through: :career_interests

  has_many :profile_interests, dependent: :destroy
  has_many :profiles, through: :profile_interests

  validates :name, presence: true
  validates :url, presence: true
  validates :home_url, presence: true
  validates :gj_url, presence: true
  validates :gj_url_selected, presence: true

  validates_uniqueness_of :name

  # Sorting by alphabetical
  scope :alphabetical, lambda {
    order(:name)
  }

  scope :filter_names_not_exist, lambda { |names|
    where('name NOT IN (?)', names)
  }

  def self.update_interest(params)
    interest = Interest.find_by_name(params[:name])

    raise "Do not found with interest: '#{params[:name]}'." unless interest.present?

    interest.update_attributes(params)
  end

  def self.find_interest(interest_name)
    interest = Interest.find_by_name(interest_name)
    unless interest.present?
      raise "Do not found with interest: '#{interest_name}'.
        Please make sure import Interest before."
    end

    interest
  end

  # Remove all interests do not exists in TSV file import
  def self.remove(names)
    interests = Interest.filter_names_not_exist(names)

    interests.delete_all if interests.present?
  end

  def self.import_from_csv(csv)
    Interest.transaction do
      # Interest.delete_all

      csv.each do |row|
        params = {
          name: row[0].strip,
          home_url: row[2].strip,
          url: row[1].strip,
          gj_url: row[3].strip,
          gj_url_selected: row[4].strip
        }

        if Interest.exists?(name: params[:name])
          # Update interest
          Interest.update_interest(params)
        else
          # Create interest
          Interest.create(params)
        end
      end

      # Remove all Interest do not exists in tsv file
      names = csv.map { |row| row[0].strip }.uniq
      Interest.remove(names)
    end
  end

  def to_s
    name
  end
end
