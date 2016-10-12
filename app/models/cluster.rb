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
        cluster = Cluster.new
        cluster[:name] = row[0].strip

        raise 'Wrong file' if row[1].present?

        cluster.save!
      end
    end
  end
end
