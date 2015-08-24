class AddExpiredToInventoryBatches < ActiveRecord::Migration
  def change
    add_column :inventory_batches, :expired, :boolean
  end
end
