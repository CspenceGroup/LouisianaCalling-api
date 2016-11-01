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

  def self.find_or_create(cluster_name)
    cluster = Cluster.find_by_name(cluster_name)

    # Adding new cluster
    cluster = Cluster.create(name: cluster_name) unless cluster.present?

    cluster
  end

  def self.import_from_csv(csv)
    Cluster.transaction do
      # Cluster.delete_all

      csv.each do |row|
        name_str = row[0].strip
        next if Cluster.exists?(name: name_str)

        cluster = Cluster.new
        cluster[:name] = name_str

        cluster.save!
      end
    end
  end

  def to_s
    name
  end
end
