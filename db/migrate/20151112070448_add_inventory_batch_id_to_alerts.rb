class AddInventoryBatchIdToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts , :inventory_batch_id , :integer
  end
end
