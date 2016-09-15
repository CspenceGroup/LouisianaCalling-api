class Video < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true
  validates :main_title, presence: true
  validates :description, presence: true
end
