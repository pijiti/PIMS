class StoreOperationsController < ApplicationController
  before_action :set_store_operation, only: [:show, :edit, :update, :destroy]


  def index
    @store_operations = StoreOperation.all
    new
  end


  def new
    @store_operation = StoreOperation.new
  end


  def edit
  end


  def create
    @store_operation = StoreOperation.new(store_operation_params)
    #authorize @store_operation
     @store_operation.save!
     @error = @store_operation.errors.full_messages
  end


  def update
      @store_operation.update!(store_operation_params)
      @error = @store_operation.errors.full_messages
  end


  def destroy
    @store_operation.destroy!
    @error = @store_operation.errors.full_messages
  end

  private
    def set_store_operation
      @store_operation = StoreOperation.find(params[:id])
    end


    def store_operation_params
      params.require(:store_operation).permit(:name, :description,:payment_required)
    end
end
