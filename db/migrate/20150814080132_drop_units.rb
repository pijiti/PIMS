class DropUnits < ActiveRecord::Migration
  def change
    remove_column :inventories , :units
  end
end
