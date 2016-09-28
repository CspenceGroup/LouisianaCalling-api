class Program < ApplicationRecord
  serialize :industries, Array

  validates_inclusion_of :duration, :in => ["8 Weeks", "3 Months", "6 Months", "1 Year", "2 Years", "4 Years", ""]
  validates_inclusion_of :time_of_day, :in => ["Day Time Only", "Night Time Only", "Full Day", ""]
  validates_inclusion_of :hours_per_weeks, :in => ["3 - 10 Hours", "11 - 20 Hours", "21 - 30 Hours", "31 - 40 Hours", ""]
  validates_inclusion_of :financial_help, :in => ["Scholarship", "Financial Aid/Grant", ""]
  validates_inclusion_of :education, :in => ["High School Diploma/GED", "JumpStart", "Training", "College", ""]
end
