class CreateTriggeredTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :triggered_tasks do |t|
      t.references :home, foreign_key: true, null: false
      t.references :thing, foreign_key: { to_table: :things }
      t.references :thing_to_compare, null: false, index: true, foreign_key: { to_table: :things }
      t.references :scenario, foreign_key: true
      t.references :delayed_job
      t.json :status_to_apply
      t.json :status_to_compare, null: false
      t.string :comparator, null: false
      t.boolean :should_apply?, default: true

      t.timestamps
    end
  end
end
