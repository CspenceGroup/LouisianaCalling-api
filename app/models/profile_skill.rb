class ProfileSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :profile
end
