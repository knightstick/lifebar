class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :interval_type
      t.datetime :last_completed_at

      t.timestamps
    end
  end
end
