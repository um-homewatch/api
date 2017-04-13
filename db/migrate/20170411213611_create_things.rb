class CreateThings < ActiveRecord::Migration[5.0]
  def change
    create_table :things do |t|
      t.integer :kind
      t.string :subtype
      t.json :payload
      t.references :home

      t.timestamps
    end
  end
end
