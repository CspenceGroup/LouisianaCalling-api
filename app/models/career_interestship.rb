class CareerInterestship < ActiveRecord::Base
  belongs_to :career
  belongs_to :career_related, class_name: 'Career', foreign_key: :career_related_id
end
