class CareerRegionEducation < ActiveRecord::Base
  belongs_to :career_region
  belongs_to :education
end
