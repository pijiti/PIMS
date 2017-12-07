class ItemConcentrationUnitsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  # before_action :set_item_concentration_unit, only: [:show, :edit, :update, :destroy]


  def index
    @item_concentration_units = ItemConcentrationUnit.all
    new
     respond_to do |format|
     	format.html
      format.xlsx
    end
  end


  def new
    @item_concentration_unit = ItemConcentrationUnit.new
  end

  def edit
  end

  def create
    @item_concentration_unit = ItemConcentrationUnit.new(item_concentration_unit_params)
    begin
    #authorize @item_concentration_unit
     @item_concentration_unit.save!
     rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end

  def update
      @item_concentration_unit.attributes = item_concentration_unit_params
      begin
      #authorize @item_concentration_unit
       @item_concentration_unit.save!
       rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def destroy
  	begin
    #authorize @item_concentration_unit
    @item_concentration_unit.destroy!
    rescue ActiveRecord::DeleteRestrictionError => e
   	@error = e.message
   end
  end

  private

    def set_item_concentration_unit
      @item_concentration_unit = ItemConcentrationUnit.find(params[:id])
    end

    def item_concentration_unit_params
      params.require(:item_concentration_unit).permit(:name,:description)
    end
end
