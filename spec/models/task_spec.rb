require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    it "requires a name" do
      task = Task.new(interval_type: "weekly")
      expect(task).not_to be_valid
      expect(task.errors[:name]).to include("can't be blank")
    end

    it "requires an interval_type" do
      task = Task.new(name: "Test task")
      expect(task).not_to be_valid
      expect(task.errors[:interval_type]).to include("can't be blank")
    end

    it "only allows valid interval types" do
      task = Task.new(name: "Test task", interval_type: "invalid")
      expect(task).not_to be_valid
      expect(task.errors[:interval_type]).to include("is not included in the list")
    end

    it "allows all valid interval types" do
      %w[daily weekly monthly custom].each do |interval_type|
        task = Task.new(name: "Test task", interval_type: interval_type)
        task.interval_value = 5 if interval_type == "custom"
        expect(task).to be_valid
      end
    end

    context "custom intervals" do
      it "requires interval_value for custom interval type" do
        task = Task.new(name: "Test task", interval_type: "custom")
        expect(task).not_to be_valid
        expect(task.errors[:interval_value]).to include("can't be blank")
      end

      it "requires positive interval_value for custom intervals" do
        task = Task.new(name: "Test task", interval_type: "custom", interval_value: 0)
        expect(task).not_to be_valid
        expect(task.errors[:interval_value]).to include("must be greater than 0")
      end

      it "is valid with positive interval_value for custom intervals" do
        task = Task.new(name: "Test task", interval_type: "custom", interval_value: 3)
        expect(task).to be_valid
      end
    end
  end

  describe "#interval_display" do
    it "returns proper display text for each interval type" do
      expect(Task.new(interval_type: "daily").interval_display).to eq("Daily")
      expect(Task.new(interval_type: "weekly").interval_display).to eq("Weekly")
      expect(Task.new(interval_type: "monthly").interval_display).to eq("Monthly")
      expect(Task.new(interval_type: "custom", interval_value: 3).interval_display).to eq("Every 3 days")
    end
  end

  describe "#interval_days" do
    it "returns correct number of days for each interval type" do
      expect(Task.new(interval_type: "daily").interval_days).to eq(1)
      expect(Task.new(interval_type: "weekly").interval_days).to eq(7)
      expect(Task.new(interval_type: "monthly").interval_days).to eq(30)
      expect(Task.new(interval_type: "custom", interval_value: 5).interval_days).to eq(5)
    end
  end

  describe "#next_due_date" do
    let(:base_time) { Time.parse("2025-01-15 12:00:00") }

    context "when task has been completed" do
      it "calculates next due date from last completion" do
        task = create(:task, :daily, :completed, completed_at: base_time)
        expect(task.next_due_date).to be_within(1.second).of(base_time + 1.day)
      end
    end

    context "when task has never been completed" do
      it "calculates next due date from creation time" do
        task = Task.new(interval_type: "weekly", created_at: base_time, last_completed_at: nil)
        expect(task.next_due_date).to be_within(1.second).of(base_time + 7.days)
      end

      it "calculates correctly for daily tasks" do
        creation_time = Time.parse("2025-01-14 12:00:00")
        task = create(:task, :daily, created_at: creation_time, last_completed_at: nil)
        expect(task.next_due_date).to be_within(1.second).of(creation_time + 1.day)
      end
    end

    it "works with different interval types" do
      daily_task = create(:task, :daily, :completed, completed_at: base_time)
      weekly_task = create(:task, :weekly, :completed, completed_at: base_time)
      monthly_task = create(:task, :monthly, :completed, completed_at: base_time)
      custom_task = create(:task, :custom, :completed, interval_value: 3, completed_at: base_time)

      expect(daily_task.next_due_date).to be_within(1.second).of(base_time + 1.day)
      expect(weekly_task.next_due_date).to be_within(1.second).of(base_time + 7.days)
      expect(monthly_task.next_due_date).to be_within(1.second).of(base_time + 30.days)
      expect(custom_task.next_due_date).to be_within(1.second).of(base_time + 3.days)
    end
  end

  describe "#overdue?" do
    let(:current_time) { Time.parse("2025-01-15 12:00:00") }

    around do |example|
      travel_to(current_time) do
        example.run
      end
    end

    it "returns true when task is overdue" do
      task = create(:task, :daily, :completed, completed_at: 2.days.ago)
      expect(task).to be_overdue
    end

    it "returns false when task is not overdue" do
      task = create(:task, :daily, :completed, completed_at: 12.hours.ago)
      expect(task).not_to be_overdue
    end

    it "returns false when task is due exactly now" do
      task = create(:task, :daily, :completed, completed_at: 1.day.ago)
      expect(task).not_to be_overdue
    end

    context "when task has never been completed" do
      it "returns false for new task due in future" do
        creation_time = Time.parse("2025-01-14 12:00:00")
        task = create(:task, :weekly, created_at: creation_time, last_completed_at: nil)
        expect(task).not_to be_overdue
      end

      it "returns true for new task that is overdue" do
        old_creation_time = Time.parse("2025-01-10 12:00:00")
        task = create(:task, :daily, created_at: old_creation_time, last_completed_at: nil)
        expect(task).to be_overdue
      end
    end
  end

  describe "#status_text" do
    let(:current_time) { Time.parse("2025-01-15 12:00:00") }

    around do |example|
      travel_to(current_time) do
        example.run
      end
    end

    context "when task is overdue" do
      it "shows overdue by days" do
        task = create(:task, :daily, :completed, completed_at: 3.days.ago)
        expect(task.status_text).to eq("Overdue by 2 days")
      end

      it "shows overdue by single day" do
        task = create(:task, :daily, :completed, completed_at: 2.days.ago)
        expect(task.status_text).to eq("Overdue by 1 day")
      end

      it "shows 'Due now' when just overdue" do
        task = create(:task, :daily, :completed, completed_at: 25.hours.ago)
        expect(task.status_text).to eq("Due now")
      end
    end

    context "when task is due in the future" do
      it "shows due in hours when less than a day" do
        task = create(:task, :daily, :completed, completed_at: 20.hours.ago)
        expect(task.status_text).to eq("Due in 4 hours")
      end

      it "shows due in single hour" do
        task = create(:task, :daily, :completed, completed_at: 23.hours.ago)
        expect(task.status_text).to eq("Due in 1 hour")
      end

      it "shows due in days when more than a day" do
        task = create(:task, :weekly, :completed, completed_at: 1.day.ago)
        expect(task.status_text).to eq("Due in 6 days")
      end

      it "shows due in single day" do
        task = create(:task, :weekly, :completed, completed_at: 6.days.ago)
        expect(task.status_text).to eq("Due in 1 day")
      end
    end

    context "when task is due exactly now" do
      it "shows 'Due now'" do
        task = create(:task, :daily, :completed, completed_at: 1.day.ago)
        expect(task.status_text).to eq("Due now")
      end
    end

    context "when task has never been completed" do
      it "shows correct text for new task due in future" do
        creation_time = Time.parse("2025-01-14 12:00:00")
        task = create(:task, :weekly, created_at: creation_time, last_completed_at: nil)
        expect(task.status_text).to eq("Due in 6 days")
      end

      it "shows correct text for new task that is overdue" do
        old_creation_time = Time.parse("2025-01-10 12:00:00")
        task = create(:task, :daily, created_at: old_creation_time, last_completed_at: nil)
        expect(task.status_text).to eq("Overdue by 4 days")
      end

      it "shows correct text for new task due now" do
        creation_time = Time.parse("2025-01-14 12:00:00")
        task = create(:task, :daily, created_at: creation_time, last_completed_at: nil)
        expect(task.status_text).to eq("Due now")
      end
    end
  end

  describe "#status_color_class" do
    let(:current_time) { Time.parse("2025-01-15 12:00:00") }

    around do |example|
      travel_to(current_time) do
        example.run
      end
    end

    it "returns red for overdue tasks" do
      task = create(:task, :daily, :completed, completed_at: 2.days.ago)
      expect(task.status_color_class).to eq("status-red")
    end

    it "returns yellow for tasks due within a day" do
      task = create(:task, :daily, :completed, completed_at: 20.hours.ago)
      expect(task.status_color_class).to eq("status-yellow")
    end

    it "returns yellow for tasks due exactly now" do
      task = create(:task, :daily, :completed, completed_at: 1.day.ago)
      expect(task.status_color_class).to eq("status-yellow")
    end

    it "returns green for tasks due exactly in one day" do
      task = create(:task, :daily, :completed, completed_at: Time.current)
      expect(task.status_color_class).to eq("status-green")
    end

    it "returns green for tasks due in more than a day" do
      task = create(:task, :weekly, :completed, completed_at: 1.day.ago)
      expect(task.status_color_class).to eq("status-green")
    end

    context "when task has never been completed" do
      it "returns green for new task due in future" do
        creation_time = Time.parse("2025-01-14 12:00:00")
        task = create(:task, :weekly, created_at: creation_time, last_completed_at: nil)
        expect(task.status_color_class).to eq("status-green")
      end

      it "returns red for new task that is overdue" do
        old_creation_time = Time.parse("2025-01-10 12:00:00")
        task = create(:task, :daily, created_at: old_creation_time, last_completed_at: nil)
        expect(task.status_color_class).to eq("status-red")
      end

      it "returns yellow for new task due now" do
        creation_time = Time.parse("2025-01-14 12:00:00")
        task = create(:task, :daily, created_at: creation_time, last_completed_at: nil)
        expect(task.status_color_class).to eq("status-yellow")
      end
    end
  end

  describe "initial state" do
    it "starts as not completed" do
      task = create(:task, :weekly)
      expect(task.last_completed_at).to be_nil
    end
  end
end
  describe "#mark_completed!" do
    let(:current_time) { Time.parse("2025-01-15 12:00:00") }

    around do |example|
      travel_to(current_time) do
        example.run
      end
    end

    it "updates last_completed_at to current time by default" do
      task = create(:task, :weekly, :completed, completed_at: 5.days.ago)

      expect { task.mark_completed! }.to change { task.reload.last_completed_at }
      expect(task.last_completed_at).to be_within(1.second).of(current_time)
    end

    it "updates last_completed_at to specified time when provided" do
      task = create(:task, :weekly)
      specified_time = 3.days.ago

      task.mark_completed!(specified_time)

      expect(task.reload.last_completed_at).to be_within(1.second).of(specified_time)
    end

    it "creates a TaskCompletion record with current time by default" do
      task = create(:task, :weekly)

      expect { task.mark_completed! }.to change { task.task_completions.count }.by(1)

      completion = task.task_completions.last
      expect(completion.completed_at).to be_within(1.second).of(current_time)
    end

    it "creates a TaskCompletion record with specified time when provided" do
      task = create(:task, :weekly)
      specified_time = 2.days.ago

      task.mark_completed!(specified_time)

      completion = task.task_completions.last
      expect(completion.completed_at).to be_within(1.second).of(specified_time)
    end

    it "ensures both operations happen atomically" do
      task = create(:task, :weekly, :completed, completed_at: 5.days.ago)

      # Mock TaskCompletion creation to fail
      allow(task.task_completions).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(TaskCompletion.new))

      expect { task.mark_completed! }.to raise_error(ActiveRecord::RecordInvalid)

      # Verify that the task's last_completed_at was not updated due to rollback
      task.reload
      expect(task.last_completed_at).to be_within(1.second).of(5.days.ago)
    end

    it "sets both timestamps to the same value" do
      task = create(:task, :weekly)
      specified_time = 1.day.ago

      task.mark_completed!(specified_time)

      completion = task.task_completions.last
      expect(task.reload.last_completed_at).to eq(completion.completed_at)
      expect(completion.completed_at).to be_within(1.second).of(specified_time)
    end
  end
