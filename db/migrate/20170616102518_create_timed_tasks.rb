class CreateTimedTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :timed_tasks do |t|
      t.references :home, foreign_key: true
      t.references :delayed_job     
      t.references :thing, foreign_key: true
      t.json :status 

      t.timestamps
    end
  end
end
