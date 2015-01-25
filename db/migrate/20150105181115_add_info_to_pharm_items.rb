class AddInfoToPharmItems < ActiveRecord::Migration
  def change
  	add_column :pharm_items, :central_restock_level, :decimal, precision: 8, scale: 2
  	add_column :pharm_items, :central_critical_level, :decimal, precision: 8, scale: 2
    add_column :pharm_items, :main_restock_level, :decimal, precision: 8, scale: 2
    add_column :pharm_items, :main_critical_level, :decimal, precision: 8, scale: 2
    add_column :pharm_items, :dispensary_restock_level, :decimal, precision: 8, scale: 2
    add_column :pharm_items, :dispensary_critical_level, :decimal, precision: 8, scale: 2
    add_column :pharm_items, :ward_restock_level, :decimal, precision: 8, scale: 2
    add_column :pharm_items, :ward_critical_level, :decimal, precision: 8, scale: 2
  end
end
