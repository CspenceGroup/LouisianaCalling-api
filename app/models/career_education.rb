class CareerEducation < ActiveRecord::Base
  belongs_to :career
  belongs_to :education
end
