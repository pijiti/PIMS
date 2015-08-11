class RampUpUnitsInInventoryBatches < ActiveRecord::Migration
  def calculate_units_in_pack(batch)
    if batch.qty and batch.brand
      batch.qty.to_f * batch.brand.pack_size.to_f
    else
      0
    end
  end

  def change
    InventoryBatch.all.each do |i|
      i.update(:units => calculate_units_in_pack(i.batch))
    end
  end
end
