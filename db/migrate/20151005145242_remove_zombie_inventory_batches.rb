class RemoveZombieInventoryBatches < ActiveRecord::Migration
  def change
    InventoryBatch.all.each do |i|
      if i.batch.blank? or i.batch.brand.blank?
        puts "deleted batch #{i.batch.id}"
        i.batch.destroy
      end
    end
  end
end
