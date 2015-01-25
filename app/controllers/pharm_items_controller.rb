class PharmItemsController < ApplicationController
  before_action :set_pharm_item, only: [:show, :edit, :update, :destroy]


  def index
    @pharm_items  = PharmItem.all
    new
  end




  def new
    @pharm_item = PharmItem.new
    @pharm_item.itemclass_pharmitems.build
    @itemclasses = ItemClass.all
    @marketers = Marketer.all
    @unit_doses = UnitDose.all
    3.times{@pharm_item.brands.build}
  end


  def edit
  	@itemclasses = ItemClass.all
  	@marketers = Marketer.all
    @unit_doses = UnitDose.all
    @item_concentration_units = ItemConcentrationUnit.all
  end


  def create
    @pharm_item = PharmItem.new(pharm_item_params)
    @pharm_item.itemclass_pharmitems.build(params[:item_class_ids])unless (params[:item_class_ids]).blank?
    @pharm_item.critical_levels

    if @pharm_item.has_brand?
        @pharm_item.save
          logger.debug " is saved "
          logger.debug " #{@pharm_item.has_brand?}"
           redirect_to pharm_items_path
    else
      redirect_to pharm_items_path
      logger.debug " #{@pharm_item.has_brand?}"
      logger.debug " is no saved"
   end
  end


  def update

      if @pharm_item.update(pharm_item_params)
      	@pharm_item.critical_levels
      	@pharm_item.save!
         redirect_to pharm_items_path
      else
         render :edit
    end
  end


  def destroy
    @pharm_item.destroy
     redirect_to pharm_items_path

  end

  private
    def set_pharm_item
      @pharm_item = PharmItem.find(params[:id])
    end

    def pharm_item_params
      params.require(:pharm_item).permit(:pharm_item_name,{:item_class_ids=>[]},:central_restock_level,:central_critical_level,:main_restock_level,
      :main_critical_level,:dispensary_restock_level,:dispensary_critical_level,:ward_restock_level,:ward_critical_level,
      brands_attributes: [:id, :brand_name,:pack_bundle, :marketer_id, :unit_dose_id, :concentration, :item_concentration_unit_id, :pack_size,:pharm_item_id,:min_dispensable])
    end
end
