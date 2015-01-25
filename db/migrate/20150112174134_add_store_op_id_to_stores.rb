class AddStoreOpIdToStores < ActiveRecord::Migration
  def change
  	add_column :stores, :store_operation_id , :integer
  	remove_column :stores, :operation_mode
  end
end
