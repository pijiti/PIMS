class AddRestockLevelToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :main_restock_level, :decimal
    add_column :brands, :dispensary_restock_level, :decimal
  end
end
