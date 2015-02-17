class RemoveNameSurchargess < ActiveRecord::Migration
  def change
  	remove_column :surcharges, :surcharge_name, :name
  	remove_column :surcharge_items, :surcharge_item_name, :name
  end
end
