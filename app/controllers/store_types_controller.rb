class StoreTypesController < ApplicationController


	#before_action :set_store, only: [:create]
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
    #authorize @store_type
    @error = @store_type.errors.full_messages.to_sentence unless @store_type.save!
  end


  def update
      @store_type.attributes = store_type_params
      #authorize @store_type
      @error = @store_type.errors.full_messages.to_sentence unless @store_type.save!
  end


  def destroy
    #authorize @store_type
   @error = @store_type.errors.full_messages.to_sentence unless @store_type.destroy!

  end

  private

    def set_store_type
      @store_type = StoreType.find(params[:id])
    end


    def store_type_params
      params.require(:store_type).permit(:name,:description)
    end
end
