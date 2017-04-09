class CreateHomes < ActiveRecord::Migration[5.0]
  def change
    create_table :homes do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.string :tunnel, null: false
      t.inet :ip_address, null: false
      t.references :user

      t.timestamps
    end

    add_index :homes, :ip_address, unique: true
  end
end
