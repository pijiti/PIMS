class CalculateInventory < ActiveRecord::Migration

  def calculate_units_in_pack(batch)
    if batch.qty and batch.brand
      batch.qty.to_f * batch.brand.pack_size.to_f
    else
      0
    end
  end

  def change
    counter = {}
    Supply.all.each do |s|
      s.batches.where(:approval_status => "APPROVED").each do |b|
        counter[[s.store_id, b.brand_id]] ||= 0
        counter[[s.store_id, b.brand_id]] += calculate_units_in_pack(b)
      end
    end
    counter.each do |k, v|
      Inventory.create(:store_id => k[0], :brand_id => k[1], :units => v)
    end
  end

end
