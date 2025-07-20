class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :interval_type, presence: true, inclusion: { in: %w[daily weekly monthly] }

  before_create :set_initial_completion_time

  private

  def set_initial_completion_time
    self.last_completed_at ||= Time.current
  end
end
