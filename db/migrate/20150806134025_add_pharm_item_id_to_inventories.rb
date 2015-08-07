class AddPharmItemIdToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :pharm_item_id, :integer

    Inventory.all.each do |i|
      i.update(:pharm_item_id => i.brand.pharm_item.id)
    end
  end
end
