class StoreOperationsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :set_store_operation, only: [:show, :edit, :update, :destroy]


  def index
    @store_operations = StoreOperation.all
    new
     respond_to do |format|
     	format.html
      format.xlsx
    end
  end


  def new
    @store_operation = StoreOperation.new
  end


  def edit
  end


  def create
    @store_operation = StoreOperation.new(store_operation_params)
    begin
    #authorize @store_operation
    @store_operation.save!
   rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def update
  	begin
      @store_operation.attributes = store_operation_params
      #authorize @store_operation
       @store_operation.save!
       rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def destroy
  	begin
    #authorize @store_operation
    @store_operation.destroy!
   	rescue ActiveRecord::DeleteRestrictionError => e
   	@error = e.message
   end
  end

  private
    def set_store_operation
      @store_operation = StoreOperation.find(params[:id])
    end


    def store_operation_params
      params.require(:store_operation).permit(:name, :description,:payment_required)
    end
end
