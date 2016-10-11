class CareerSkill < ActiveRecord::Base
  belongs_to :career
  belongs_to :skill
end
