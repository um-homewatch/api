class AddScenarioToTimedTasks < ActiveRecord::Migration[5.0]
  def change
    add_reference :timed_tasks, :scenario, foreign_key: true
  end
end
