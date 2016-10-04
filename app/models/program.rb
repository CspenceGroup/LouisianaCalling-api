class Program < ApplicationRecord
  serialize :industries, Array
  serialize :interests, Array
  serialize :career, Array

  validates_inclusion_of :duration, :in => ["8 Weeks", "3 Months", "6 Months", "1 Year or 2 Semesters", "2 Years or 4 Semesters", "2 Years+", ""]
  validates_inclusion_of :time_of_day, :in => ["Day", "Night", "Both", ""]
  validates_inclusion_of :hours_per_weeks, :in => ["3 - 10 Hours", "11 - 20 Hours", "21 - 30 Hours", "31 - 40 Hours", ""]
  validates_inclusion_of :financial_help, :in => ["Scholarship", "Financial Aid/Grant", ""]
  validates_inclusion_of :education, :in => ["High School Diploma/Hi-SET", "Certificate or Credential", "Associate's Degree", "Bachelor's Degree", "Master's Degree", ""]
end
