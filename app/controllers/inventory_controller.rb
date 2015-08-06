class InventoryController < ApplicationController
  def index
    @inventories = Inventory.includes(:store , :brand).where(:store => current_store)
    @stores = Store.all
    @brands = Brand.all
    @pharm_items = PharmItem.all
    @filter = Inventory.new(:store => current_store  , :brand => nil)
    respond_to do |format|
      format.html
      format.csv { send_data @inventories.to_csv }
    end
  end

  def filter
    store = params[:inventory][:store]
    brand = params[:inventory][:brand]
    generic = params[:inventory][:generic_drug]
    logger.debug params[:inventory]
    @inventories = Inventory.all
    @inventories = Inventory.includes(:store , :brand).where(:store => store) if !store.blank?
    @inventories = @inventories.includes(:store , :brand).where(:brand => brand) if !brand.blank?
    @inventories = @inventories.includes(:store , :brand).where(:brand => PharmItem.find_by_id(generic).brands) if !generic.blank? and !PharmItem.find_by_id(generic).blank?

  end

  #bulk upload
  def import
    Inventory.import(params[:file])
    redirect_to inventory_index_path, notice: "Drugs imported."
  end

end
