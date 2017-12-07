class StoreTypesController < ApplicationController

	#before_action :set_store, only: [:create]
  authorize_resource
  before_action :set_store_type, only: [:show, :edit, :update, :destroy]


  def index
    @store_types = StoreType.all
    new
    respond_to do |format|
     	format.html
      format.xlsx
    end
  end

  def new
    @store_type = StoreType.new
  end


  def edit
  end


  def create
    @store_type = StoreType.new(store_type_params)
    begin
    #authorize @store_type
    @store_type.save!
    rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def update
  	begin
      @store_type.attributes = store_type_params
      #authorize @store_type
       @store_type.save!
       rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def destroy
  	begin
    #authorize @store_type
    @store_type.destroy!
    rescue ActiveRecord::DeleteRestrictionError => e
   	@error = e.message
   end

  end

  private

    def set_store_type
    	begin
      @store_type = StoreType.find(params[:id])
     rescue ActiveRecord::RecordNotFound => e
     	@error = e.message
     	logger.debug "Epitome: #{@error}"
     end
    end


    def store_type_params
      params.require(:store_type).permit(:name,:description)
    end
end
