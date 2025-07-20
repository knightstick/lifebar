class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :interval_type, presence: true, inclusion: { in: %w[daily weekly monthly] }
end
