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

    it "is valid with name and valid interval_type" do
      task = Task.new(name: "Test task", interval_type: "weekly")
      expect(task).to be_valid
    end
  end

  describe "before_create callback" do
    it "sets initial completion time" do
      task = Task.create!(name: "Test task", interval_type: "weekly")
      expect(task.last_completed_at).to be_present
      expect(task.last_completed_at).to be_within(1.second).of(Time.current)
    end
  end
end
