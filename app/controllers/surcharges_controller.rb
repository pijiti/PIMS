class SurchargesController < ApplicationController
	before_action :set_surcharge, only: [:edit,:update,:destroy]
	before_action :set_all_surcharges, only: [:index]
	respond_to :html


  def index
  	new
  end

  def new
  	@surcharge = Surcharge.new
     3.times  do
     	    @surcharge.surcharge_items.build
     end
  end

  def create
  	@surcharge = Surcharge.create!(surcharge_params)
  	 redirect_to surcharges_path
  end

  def update
  	@surcharge = update(surcharge_params)
  	 redirect_to surcharges_path
  end

  def destroy
  	@surcharge.destroy
  	 redirect_to surcharges_path
  end


  private

  def set_surcharge
  	@surcharge = Surcharge.find(params[:id])
  end

  def set_all_surcharges
  	@surcharges = Surcharge.all
  end

  def surcharge_params
      params.require(:surcharge).permit(:surcharge_name, :surcharge_type, :active,
                                                                    surcharge_items_attributes: [:id,:surcharge_item_name, :description,:value])
    end

end
