class TaskCompletion < ApplicationRecord
  belongs_to :task

  validates :completed_at, presence: true
end
