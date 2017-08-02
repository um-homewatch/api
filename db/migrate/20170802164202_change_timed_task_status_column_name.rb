class ChangeTimedTaskStatusColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :timed_tasks, :status, :status_to_apply
  end
end
