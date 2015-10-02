class RenameColumnInventory < ActiveRecord::Migration
  def change
    rename_column :collation_batches , :batch_id , :inventory_batch_id
  end
end
