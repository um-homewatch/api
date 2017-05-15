class AddNameToThings < ActiveRecord::Migration[5.0]
  def change
    add_column :things, :name, :string
  end
end
