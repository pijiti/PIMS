class ItemConcentrationUnitsController < ApplicationController
  before_action :set_item_concentration_unit, only: [:show, :edit, :update, :destroy]


  def index
    @item_concentration_units = ItemConcentrationUnit.all
    new
  end


  def new
    @item_concentration_unit = ItemConcentrationUnit.new
  end

  def edit
  end

  def create
    @item_concentration_unit = ItemConcentrationUnit.new(item_concentration_unit_params)
      if @item_concentration_unit.save
        redirect_to item_concentration_units_path
      else
        render :new
    end
  end

  def update
      if @item_concentration_unit.update(item_concentration_unit_params)
         redirect_to item_concentration_units_path
      else
        render :edit
    end
  end


  def destroy
    @item_concentration_unit.destroy
     redirect_to item_concentration_units_path
  end

  private

    def set_item_concentration_unit
      @item_concentration_unit = ItemConcentrationUnit.find(params[:id])
    end

    def item_concentration_unit_params
      params.require(:item_concentration_unit).permit(:conc_unit_name,:description)
    end
end
