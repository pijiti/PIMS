class SurchargesController < ApplicationController
	before_action :set_surcharge, only: [:edit,:update,:destroy]
	before_action :set_all_surcharges, only: [:index]
	#respond_to :html


  def index
  	new
  end

  def new
  	@surcharge = Surcharge.new
    @surcharge.surcharge_items.build
  end

   def edit
   	@surcharge.surcharge_items.build
  end


  def create
  	@surcharge = Surcharge.new(surcharge_params)
  	 authorize @surcharge
  	@error = @surcharge.errors.full_messages.to_sentence unless @surcharge.save!
  end

  def update
  	@surcharge.attributes = surcharge_params
  	 authorize @surcharge
  	 @error = @surcharge.errors.full_messages.to_sentence unless @surcharge.save!
  end

  def destroy
  	authorize @surcharge
  	@error = @surcharge.errors.full_messages.to_sentence unless @surcharge.destroy!
  end


  private

  def set_surcharge
  	@surcharge = Surcharge.find(params[:id])
  end

  def set_all_surcharges
  	@surcharges = Surcharge.all
  end

  def surcharge_params
      params.require(:surcharge).permit(:name, :type, :active,
                                                                    surcharge_items_attributes: [:id,:name, :description,:value])
    end

end
