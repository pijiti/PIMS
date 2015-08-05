class AddRatePerUnitToSupplies < ActiveRecord::Migration
  def change
    add_column :inventories, :rate_per_unit, :float
  end
end
