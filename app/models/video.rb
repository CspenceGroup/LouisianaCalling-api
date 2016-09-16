class Video < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true
  validates :main_title, presence: true
  validates :description, presence: true

  def descriptions
    self.description.split('.')
  end
end
