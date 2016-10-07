class Cluster < ApplicationRecord
  validates :name, presence: true

  def self.import_from_csv(csv)
    Cluster.transaction do
      Cluster.delete_all

      csv.each do |row|
        cluster = Cluster.new
        cluster[:name] = row[0].strip

        if row[1]
          raise "Wrong file"
        end

        cluster.save!
      end
    end
  end
end
