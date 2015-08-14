class RampUpBrands < ActiveRecord::Migration
  def change
    Store.all.each do |store|
      Brand.all.each do |brand|
        next if !Inventory.where(:store => store , :brand => brand).blank?
        logger.info "======creating======#{store.id}======#{brand.id}"
        Inventory.create(:store => store , :brand => brand , :pharm_item => brand.pharm_item)
      end
    end
  end
end
