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

  def interval_days
    case interval_type
    when "daily"
      1
    when "weekly"
      7
    when "monthly"
      30
    when "custom"
      interval_value
    end
  end

  def next_due_date
    base_time = last_completed_at || created_at
    base_time + interval_days.days
  end

  def overdue?
    next_due_date < Time.current
  end

  def status_text
    time_diff = next_due_date - Time.current

    if time_diff <= 0
      hours_overdue = (-time_diff / 1.hour).ceil
      if hours_overdue <= 1
        "Due now"
      else
        days_overdue = (-time_diff / 1.day).ceil
        "Overdue by #{days_overdue} #{'day'.pluralize(days_overdue)}"
      end
    else
      hours_until_due = (time_diff / 1.hour).ceil
      days_until_due = (time_diff / 1.day).floor

      if days_until_due == 0
        "Due in #{hours_until_due} #{'hour'.pluralize(hours_until_due)}"
      else
        "Due in #{days_until_due} #{'day'.pluralize(days_until_due)}"
      end
    end
  end

  def status_color_class
    time_diff = next_due_date - Time.current

    if time_diff <= 0
      "status-red"
    elsif time_diff <= 1.day
      "status-yellow"
    else
      "status-green"
    end
  end
end
