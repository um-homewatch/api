class CreateTriggeredTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :triggered_tasks do |t|
      t.references :home, foreign_key: true, null: false
      t.references :thing, foreign_key: true, null: false
      t.references :scenario, foreign_key: true    
      t.references :delayed_job       
      t.json :status_to_apply
      t.json :status_to_compare, null: false
      t.string :keys_to_compare, array: true
      t.integer :comparator_type, null: false

      t.timestamps
    end
  end
end
