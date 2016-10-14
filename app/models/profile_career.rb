class ProfileCareer < ActiveRecord::Base
  belongs_to :profile
  belongs_to :career
end
