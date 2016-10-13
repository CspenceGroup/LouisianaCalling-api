class ProfileEducation < ActiveRecord::Base
  belongs_to :education
  belongs_to :profile
end
