class PharmItemsController < ApplicationController
  before_action :set_pharm_item, only: [:show, :edit, :update, :destroy]


  def index
    @pharm_items  = PharmItem.all
    new
     respond_to do |format|
     	  format.html
        format.xlsx
    end
  end




  def new
    @pharm_item = PharmItem.new
    @pharm_item.pharm_item_sub_classes.build
    @subclasses = SubClass.all
    @marketers = Marketer.all
    @unit_doses = UnitDose.all
    @pharm_item.brands.build
 end

  def edit
  	@itemclasses = ItemClass.all
  	@pharm_item.pharm_item_sub_classes.build
  	@marketers = Marketer.all
    @unit_doses = UnitDose.all
    @pharm_item.brands.build
  end


  def create
    @pharm_item = PharmItem.new(pharm_item_params)
    begin
    #authorize @pharm_item
    @pharm_item.pharm_item_sub_classes.build(params[:sub_class_ids])if (params[:sub_class_ids]).present?
    @pharm_item.critical_levels
    @pharm_item.save! #unless @pharm_item.has_brand? == true
   rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end

  end


  def update
     	  @pharm_item.attributes = pharm_item_params
     	  #authorize @pharm_item
      	@pharm_item.critical_levels
      	#if  @pharm_item.has_brand? == true
      		@pharm_item.save!

  end


  def destroy
   	#authorize @pharm_item
    @error = @pharm_item.errors.full_messages.to_sentence unless   @pharm_item.destroy!
  end

  private
    def set_pharm_item
      @pharm_item = PharmItem.find(params[:id])
    end

    def pharm_item_params
      params.require(:pharm_item).permit(:name,{:sub_class_ids=>[]},:central_restock_level,:central_critical_level,:main_restock_level,
      :main_critical_level,:dispensary_restock_level,:dispensary_critical_level,:ward_restock_level,:ward_critical_level,
      brands_attributes: [:id, :name,:pack_bundle, :marketer_id, :unit_dose_id, :concentration, :item_concentration_unit_id, :pack_size,:pharm_item_id,:min_dispensable ,  :_destroy])
    end
end
