class CreateTaskCompletions < ActiveRecord::Migration[8.0]
  def change
    create_table :task_completions do |t|
      t.references :task, null: false, foreign_key: { on_delete: :cascade }
      t.datetime :completed_at, null: false

      t.timestamps
    end

    add_index :task_completions, :completed_at
  end
end
