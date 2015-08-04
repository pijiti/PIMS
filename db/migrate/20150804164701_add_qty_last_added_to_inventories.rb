class AddQtyLastAddedToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :qty_last_added, :string
  end
end
