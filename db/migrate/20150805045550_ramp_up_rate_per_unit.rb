class RampUpRatePerUnit < ActiveRecord::Migration
  def calculate_units_in_pack(batch)
    if batch.qty and batch.brand
      batch.qty.to_f * batch.brand.pack_size.to_f
    else
      0
    end
  end
  def change
    Inventory.all.each do |i|
      next if Batch.where(:brand => i.brand).blank?
      i.update(:rate_per_unit => Batch.where(:brand => i.brand).last.rate / calculate_units_in_pack(Batch.where(:brand => i.brand).last))
    end
  end
end
