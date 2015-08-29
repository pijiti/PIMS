class RampingUpBatches < ActiveRecord::Migration

  def change
     Batch.all.each do |batch|
      next if !batch.inventory_batches.blank?  or batch.supply.blank?
      InventoryBatch.create(:inventory => Inventory.where(:brand_id => batch.brand_id , :store => batch.supply.store).first ,
                            :batch => batch, :units =>  batch.qty.to_i * batch.brand.pack_size.to_i)
    end
  end


end
