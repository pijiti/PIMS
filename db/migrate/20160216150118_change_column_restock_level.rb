class ChangeColumnRestockLevel < ActiveRecord::Migration
  def change
    change_column :pharm_items , :main_restock_level , :decimal , default: 0
    change_column :pharm_items , :dispensary_restock_level , :decimal , default: 0
    change_column :brands , :main_restock_level , :decimal , default: 0
    change_column :brands , :dispensary_restock_level , :decimal , default: 0
  end
end
