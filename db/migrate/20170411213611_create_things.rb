class CreateThings < ActiveRecord::Migration[5.0]
  def change
    create_table :things do |t|
      t.integer :type
      t.string :subtype
      t.references :home

      t.timestamps
    end
  end
end
