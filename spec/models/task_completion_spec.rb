require 'rails_helper'

RSpec.describe TaskCompletion, type: :model do
  describe "associations" do
    it "belongs to a task" do
      task = Task.create!(name: "Test task", interval_type: "weekly")
      completion = TaskCompletion.create!(task: task, completed_at: Time.current)

      expect(completion.task).to eq(task)
    end
  end

  describe "validations" do
    it "requires a task" do
      completion = TaskCompletion.new(completed_at: Time.current)
      expect(completion).not_to be_valid
      expect(completion.errors[:task]).to include("must exist")
    end

    it "requires completed_at" do
      task = Task.create!(name: "Test task", interval_type: "weekly")
      completion = TaskCompletion.new(task: task)
      expect(completion).not_to be_valid
      expect(completion.errors[:completed_at]).to include("can't be blank")
    end

    it "is valid with task and completed_at" do
      task = Task.create!(name: "Test task", interval_type: "weekly")
      completion = TaskCompletion.new(task: task, completed_at: Time.current)
      expect(completion).to be_valid
    end
  end

  describe "database constraints" do
    it "cascades delete when task is deleted" do
      task = Task.create!(name: "Test task", interval_type: "weekly")
      completion = TaskCompletion.create!(task: task, completed_at: Time.current)

      expect { task.destroy }.to change { TaskCompletion.count }.by(-1)
    end
  end
end
