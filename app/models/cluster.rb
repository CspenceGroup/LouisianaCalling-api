# == Schema Information
#
# Table name: clusters
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Cluster < ActiveRecord::Base
  has_many :profiles

  has_many :career_clusters, dependent: :destroy
  has_many :careers, through: :career_clusters

  validates :name, presence: true
  validates_uniqueness_of :name

  def self.import_from_csv(csv)
    Cluster.transaction do
      Cluster.delete_all

      csv.each do |row|
        next if Cluster.exists?(name: row[0].strip)

        cluster = Cluster.new
        cluster[:name] = row[0].strip

        raise 'Wrong file' if row[1].present?

        cluster.save!
      end
    end
  end

  def to_s
    name
  end
end
