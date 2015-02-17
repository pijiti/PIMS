class StoreTypesController < ApplicationController


	before_action :set_store, only: [:create]
  before_action :set_store_type, only: [:show, :edit, :update, :destroy]


  def index
    @store_types = StoreType.all
    new
  end

  def new
    @store_type = StoreType.new
  end


  def edit
  end


  def create
    @store_type = StoreType.new(store_type_params)
    logger.debug{"Epitome #{ session[:store_id]}" }
     @store_type.save!
  end


  def update
      @store_type.update!(store_type_params)
  end


  def destroy
    @store_type.destroy!
   @error = @store_type.errors.full_messages
  end

  private

    def set_store_type
      @store_type = StoreType.find(params[:id])
    end


    def store_type_params
      params.require(:store_type).permit(:name,:description)
    end
end
