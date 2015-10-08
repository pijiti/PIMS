class CheckRatePerUnitForInventories < ActiveRecord::Migration
  def change
    Inventory.where(:rate_per_unit => nil).each do |i|
      i.update(:rate_per_unit =>  Inventory.where(:brand => i.brand).where.not(:rate_per_unit => nil).try(:last).try(:rate_per_unit))
    end
  end
end
