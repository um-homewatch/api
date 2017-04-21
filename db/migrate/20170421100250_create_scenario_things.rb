class CreateScenarioThings < ActiveRecord::Migration[5.0]
  def change
    create_table :scenario_things do |t|
      t.references :thing
      t.references :scenario
      t.json :status

      t.timestamps
    end
  end
end
