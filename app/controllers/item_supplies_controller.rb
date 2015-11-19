class ItemSuppliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_supply, only: [:index,:create,:new]
  before_action :set_item_supply, only: [:edit,:update,:destroy]
  before_action :set_all_item_supply, only: [:index]



  def index
    new
  end



  def new
    @item_supply = @supply.item_supplies.new
    @pharm_items = PharmItem.all
    @brands = Brand.all
     3.times  do
     	    @item_supply.batches.build
     end
  end


  def edit
  	@pharm_items = PharmItem.all
    @brands = Brand.all
  end


  def create
    @item_supply = @supply.item_supplies.new(item_supply_params)
      if @item_supply.save
         redirect_to item_supplies_path(supply_id: @item_supply.supply_id)
      else
       render :new
    end
  end


  def update
      if @item_supply.update(item_supply_params)
      	redirect_to item_supplies_path(supply_id: @item_supply.supply_id)
      else
        render :edit
    end
  end


  def destroy
  	 supply_id = @item_supply.supply_id
    @item_supply.destroy
     redirect_to item_supplies_path(supply_id: supply_id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supply
      @supply = Supply.find(params[:supply_id])
    end

    def set_all_item_supply
    	@item_supplies = @supply.item_supplies.all
    end

    def set_item_supply
    	@item_supply = ItemSupply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_supply_params
      params.require(:item_supply).permit(:pharm_item_id,:brand_id,:rate,
                                                                   batches_attributes: [:id,:qty, :batch_number,:mfd_date, :expiry_date])
    end
end
