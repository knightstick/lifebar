class Task < ApplicationRecord
  has_many :task_completions, dependent: :destroy

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
    case due_state
    when :overdue
      "Overdue by #{days_overdue} #{'day'.pluralize(days_overdue)}"
    when :due_now
      "Due now"
    when :due_soon
      "Due in #{hours_until_due} #{'hour'.pluralize(hours_until_due)}"
    when :on_track
      "Due in #{days_until_due} #{'day'.pluralize(days_until_due)}"
    end
  end

  def status_color_class
    case due_state
    when :overdue
      "status-red"
    when :due_now
      "status-yellow"
    when :due_soon
      "status-yellow"
    when :on_track
      "status-green"
    end
  end

  def mark_completed!(completed_at = Time.current)
    ActiveRecord::Base.transaction do
      completion = task_completions.create!(completed_at: completed_at)
      update!(last_completed_at: completion.completed_at)
    end
  end

  def status_bar_percentage
    time_since_last_completion = Time.current - (last_completed_at || created_at)
    total_interval_seconds = interval_days.days.to_f
    
    percentage = (time_since_last_completion / total_interval_seconds) * 100
    [[percentage, 0].max, 100].min
  end

  def status_bar_color_class
    percentage = status_bar_percentage
    
    if percentage <= 25
      "bg-green-500"
    elsif percentage <= 50
      "bg-green-400"
    elsif percentage <= 75
      "bg-yellow-400"
    elsif percentage <= 90
      "bg-orange-400"
    else
      "bg-red-500"
    end
  end

  private

  def time_until_due
    @time_until_due ||= next_due_date - Time.current
  end

  def due_state
    if time_until_due < -1.hour
      :overdue
    elsif time_until_due <= 0
      :due_now
    elsif time_until_due < 1.day
      :due_soon
    else
      :on_track
    end
  end

  def hours_until_due
    (time_until_due / 1.hour).ceil
  end

  def days_until_due
    (hours_until_due / 24.0).floor
  end

  def days_overdue
    (hours_until_due.abs / 24.0).ceil
  end
end
