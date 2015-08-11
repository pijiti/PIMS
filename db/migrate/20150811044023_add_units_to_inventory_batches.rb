class AddUnitsToInventoryBatches < ActiveRecord::Migration
  def change
    add_column :inventory_batches, :units, :integer
  end
end
