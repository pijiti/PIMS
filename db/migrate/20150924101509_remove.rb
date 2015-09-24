class Remove < ActiveRecord::Migration
  def change
    Inventory.all.each do |i|
      if i.pharm_item.blank?
        i.destroy
      end
    end
  end
end
