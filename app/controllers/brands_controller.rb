class BrandsController < ApplicationController
  before_action :set_brand, only: [:edit,:show,:update,:destroy]


  def index
    @brands = Brand.all
  end

  def new
    @brand = Brand.new
    @marketers = Marketer.all
    @unit_doses = UnitDose.all
    @item_concentration_units = ItemConcentrationUnit.all
  end

  def edit
  	@brand = Brand.find(params[:id])
  end


  def create
    @brand = Brand.new(brand_params)
      if @brand.save
        redirect_to brands_path
      else
        render :new
    end
  end

  def update
      if @brand.update_attributes(brand_params)
        redirect_to brands_path
      else
         render :edit
    end
  end
  def destroy
    @brand.destroy
       redirect_to brands_path
  end

  private

    def set_brand
      @brand = Brand.find(params[:id])
    end

    def set_all_brand
    	@brands = Brand.all
    end

    def brand_params
      params.require(:brand).permit(:brand_name, :marketer_id, :unit_dose_id, :concentration, :item_concentration_unit_id, :pack_size)
    end
end
