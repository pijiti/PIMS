class InventoryController < ApplicationController

  #get rate
  def rate
    @inventory=Inventory.where(:store_id => params[:store_id], :brand_id => params[:brand_id]).first
    result = {}
    result["row"] = params[:row_id]
    if @inventory.try(:rate_per_unit)
      result["rate"] = @inventory.try(:rate_per_unit)
    else
      result["rate"] = "NA"
    end
    result["min_dispensable"] = @inventory.try(:brand).try(:min_dispensable).try(:to_i).try(:to_s)
    puts result
    respond_to do |format|
      format.json { render json: result }
    end
  end

  def index
    @inventories = Inventory.includes(:store, :brand, :pharm_item, :batches).where(:store => current_store).order("pharm_item_id")
    store_ids = []

    if can? :manage, :all
      @stores = Store.all
    else
      store_ids = Store.where(:parent_id => current_store.id).pluck(:id)
      store_ids << current_store.id
      @stores = Store.where(:id => store_ids)
    end

    #@stores = Store.all
    @brands = Brand.order('name ASC').all
    @pharm_items = PharmItem.all
    @filter = Inventory.new(:store => current_store, :brand => nil)
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
    @inventories = Inventory.includes(:store, :brand, :pharm_item, :batches).where(:store => store).order("pharm_item_id") if !store.blank?
    @inventories = @inventories.includes(:store, :brand, :pharm_item, :batches).where(:brand => brand).order("pharm_item_id") if !brand.blank?
    @inventories = @inventories.includes(:store, :brand, :pharm_item, :batches).where(:pharm_item_id => generic).order("pharm_item_id") if !generic.blank?

  end

  #bulk upload
  def import
    Inventory.import(params[:file])
    redirect_to inventory_index_path, notice: "Drugs imported."
  end

end
