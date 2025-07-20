class AddNotNullConstraintsToTasks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tasks, :name, false
    change_column_null :tasks, :interval_type, false
  end
end
