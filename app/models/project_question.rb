class ProjectQuestion < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :project
end
