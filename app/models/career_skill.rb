class CareerSkill < ActiveRecord::Base
  has_one :career
  has_one :career, as: :related_by_skill
end
