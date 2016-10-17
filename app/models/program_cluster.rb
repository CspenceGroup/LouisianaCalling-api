class ProgramCluster < ActiveRecord::Base
  belongs_to :program
  belongs_to :cluster
end
