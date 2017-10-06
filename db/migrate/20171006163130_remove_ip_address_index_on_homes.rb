class RemoveIpAddressIndexOnHomes < ActiveRecord::Migration[5.1]
  def change
    remove_index :homes, :ip_address
  end
end
