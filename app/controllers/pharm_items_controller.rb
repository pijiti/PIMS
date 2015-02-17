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
    @pharm_item.brands.build
 end

  def edit
  	@itemclasses = ItemClass.all
  	@pharm_item.itemclass_pharmitems.build
  	@marketers = Marketer.all
    @unit_doses = UnitDose.all
    @pharm_item.brands.build
  end


  def create
    @pharm_item = PharmItem.create!(pharm_item_params)
    @pharm_item.itemclass_pharmitems.build(params[:item_class_ids])unless (params[:item_class_ids]).blank?
    @pharm_item.critical_levels
    @pharm_item.save! unless @pharm_item.has_brand? == false
    @error = @pharm_item.error.full_messages
  end


  def update
     	  @pharm_item.update!(pharm_item_params)
      	@pharm_item.critical_levels
      	@pharm_item.save! unless @pharm_item.has_brand? == false
				@error = @pharm_item.error.full_messages
  end


  def destroy
    @pharm_item.destroy!
    @error = @pharm_item.error.full_messages
  end

  private
    def set_pharm_item
      @pharm_item = PharmItem.find(params[:id])
    end

    def pharm_item_params
      params.require(:pharm_item).permit(:name,{:item_class_ids=>[]},:central_restock_level,:central_critical_level,:main_restock_level,
      :main_critical_level,:dispensary_restock_level,:dispensary_critical_level,:ward_restock_level,:ward_critical_level,
      brands_attributes: [:id, :name,:pack_bundle, :marketer_id, :unit_dose_id, :concentration, :item_concentration_unit_id, :pack_size,:pharm_item_id,:min_dispensable])
    end
end
