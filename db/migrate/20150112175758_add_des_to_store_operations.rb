class AddDesToStoreOperations < ActiveRecord::Migration
  def change
  	add_column :store_operations, :description, :text
  end
end
