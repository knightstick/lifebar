class AddIntervalValueToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :interval_value, :integer
  end
end
