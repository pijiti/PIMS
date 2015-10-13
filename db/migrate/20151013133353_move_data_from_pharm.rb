class MoveDataFromPharm < ActiveRecord::Migration
  def change
    PharmItem.includes(:brands).all.each do |p|
      p.brands.update_all(:main_restock_level => p.main_restock_level , :dispensary_restock_level => p.dispensary_restock_level)
    end
  end
end
