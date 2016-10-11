class CareerInterest < ActiveRecord::Base
  belongs_to :career
  belongs_to :interest
end
