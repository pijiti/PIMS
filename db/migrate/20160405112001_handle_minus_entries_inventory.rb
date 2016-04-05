class HandleMinusEntriesInventory < ActiveRecord::Migration
  def change
    InventoryBatch.where("units < ?" , 0).update_all(:units => 0)
  end
end
