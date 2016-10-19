class CareerRegionHighDemand < ActiveRecord::Base
  belongs_to :career
  belongs_to :region
end
