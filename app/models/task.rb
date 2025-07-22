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

  def time_until_due
    @time_until_due ||= next_due_date - Time.current
  end

  def due_state
    if time_until_due < 0
      :overdue
    elsif time_until_due < 1.day
      :due_soon
    else
      :on_track
    end
  end

  def status_text
    case due_state
    when :overdue
      hours_overdue = (-time_until_due / 1.hour).ceil
      if hours_overdue <= 1
        "Due now"
      else
        days_overdue = (-time_until_due / 1.day).ceil
        "Overdue by #{days_overdue} #{'day'.pluralize(days_overdue)}"
      end
    when :due_soon
      hours_until_due = (time_until_due / 1.hour).ceil
      if hours_until_due <= 0
        "Due now"
      else
        "Due in #{hours_until_due} #{'hour'.pluralize(hours_until_due)}"
      end
    when :on_track
      days_until_due = (time_until_due / 1.day).floor
      "Due in #{days_until_due} #{'day'.pluralize(days_until_due)}"
    end
  end

  def status_color_class
    case due_state
    when :overdue
      "status-red"
    when :due_soon
      "status-yellow"
    when :on_track
      "status-green"
    end
  end
end
