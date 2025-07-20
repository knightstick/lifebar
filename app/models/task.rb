class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :interval_type, presence: true, inclusion: { in: %w[daily weekly monthly custom] }
  validates :interval_value, presence: true, numericality: { greater_than: 0 }, if: :custom_interval?

  def custom_interval?
    interval_type == "custom"
  end

  def interval_display
    case interval_type
    when "daily"
      "Daily"
    when "weekly"
      "Weekly"
    when "monthly"
      "Monthly"
    when "custom"
      "Every #{interval_value} days"
    end
  end
end
