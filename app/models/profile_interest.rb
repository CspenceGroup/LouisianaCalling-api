class ProfileInterest < ActiveRecord::Base
  belongs_to :interest
  belongs_to :profile
end
