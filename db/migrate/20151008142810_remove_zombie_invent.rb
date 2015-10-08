class RemoveZombieInvent < ActiveRecord::Migration
  def change
    Inventory.all.each do |i|
      if i.brand.blank? or i.store.blank?
       i.destroy
      end
    end
  end
end
