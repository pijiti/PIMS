class AddStoreRolesToStores < ActiveRecord::Migration
  def change
    add_column :stores, :store_roles, :text
  end
end
