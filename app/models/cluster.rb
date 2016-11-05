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

  scope :filter_names_not_exist, lambda { |names|
    where('name NOT IN (?)', names)
  }

  # Sorting by alphabetical
  scope :alphabetical, lambda {
    order(:name)
  }

  # Remove all clusters do not exists in TSV file import
  def self.remove(names)
    clusters = Cluster.filter_names_not_exist(names)

    clusters.delete_all if clusters.present?
  end

  def self.find_cluster(cluster_name)
    cluster = Cluster.find_by_name(cluster_name)

    unless cluster.present?
      raise "Do not found with industry: '#{cluster_name}'.
        Please make sure import Industry (Cluster) before."
    end

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

      # Remove all Cluster do not exists in tsv file
      names = csv.map { |row| row[0].strip }.uniq
      Cluster.remove(names)
    end
  end

  def to_s
    name
  end
end
