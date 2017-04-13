class CreateThings < ActiveRecord::Migration[5.0]
  def change
    create_table :things do |t|
      t.string :type
      t.string :subtype
      t.json :connection_info
      t.references :home

      t.timestamps
    end
  end
end
