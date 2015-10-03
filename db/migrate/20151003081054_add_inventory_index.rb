class AddInventoryIndex < ActiveRecord::Migration
  def change
    add_index :inventories, [:brand_id, :pharm_item_id, :store_id], name: "inventory_index"
    add_index :inventory_batches, [:inventory_id, :batch_id , :units], name: "inventory_batches_index"
    add_index :brands , [:pharm_item_id, :marketer_id , :unit_dose_id , :item_concentration_unit_id ] , name: "brands_index"
  end
end
