class CareerInterest < ActiveRecord::Base
  has_one :career
  has_one :career, as: :related_by_interest
end
