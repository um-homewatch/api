class AddTokenToHome < ActiveRecord::Migration[5.0]
  def change
    add_column :homes, :token, :string
    add_reference :homes, :delayed_job
  end
end
