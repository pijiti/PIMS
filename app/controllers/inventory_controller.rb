class InventoryController < ApplicationController
  def index
    @inventories = Inventory.includes(:store , :brand).where(:store => current_store)
    @stores = Store.all
    @brands = Brand.all
    @filter = Inventory.new(:store => current_store  , :brand => nil)
  end

  def filter
    store = params[:inventory][:store]
    brand = params[:inventory][:brand]
    if !store.blank? and !brand.blank?
      @inventories = Inventory.includes(:store , :brand).where(:store_id => store , :brand_id => brand)
    elsif store.blank? and !brand.blank?
      @inventories = Inventory.includes(:store , :brand).where( :brand_id => brand)
    elsif !store.blank? and brand.blank?
      @inventories = Inventory.includes(:store , :brand).where(:store_id => store)
    else
      #both blank
      @inventories = Inventory.includes(:store , :brand).where(:store => current_store)
    end

  end

end
