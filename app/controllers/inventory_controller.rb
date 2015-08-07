class InventoryController < ApplicationController
  def index
    @inventories = Inventory.includes(:store , :brand , :pharm_item , :batches).where(:store => current_store).order("pharm_item_id")
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
    @inventories = Inventory.all.order("pharm_item_id")
    @inventories = Inventory.includes(:store , :brand , :pharm_item, :batches).where(:store => store).order("pharm_item_id") if !store.blank?
    @inventories = @inventories.includes(:store , :brand, :pharm_item, :batches).where(:brand => brand).order("pharm_item_id") if !brand.blank?
    @inventories = @inventories.includes(:store , :brand, :pharm_item, :batches).where(:pharm_item_id => generic).order("pharm_item_id") if !generic.blank?

  end

  #bulk upload
  def import
    Inventory.import(params[:file])
    redirect_to inventory_index_path, notice: "Drugs imported."
  end

end
