class StoreOperationsController < ApplicationController
  before_action :set_store_operation, only: [:show, :edit, :update, :destroy]


  def index
    @store_operations = StoreOperation.all
  end


  def new
    @store_operation = StoreOperation.new
  end


  def edit
  end


  def create
    @store_operation = StoreOperation.new(store_operation_params)
      if @store_operation.save
         redirect_to store_operations_path
      else
        render :new
    end
  end


  def update
      if @store_operation.update(store_operation_params)
     redirect_to store_operations_path
      else
        render :edit
    end
  end


  def destroy
    @store_operation.destroy
    redirect_to store_operations_url
  end

  private
    def set_store_operation
      @store_operation = StoreOperation.find(params[:id])
    end


    def store_operation_params
      params.require(:store_operation).permit(:store_operation_name, :description,:payment_required)
    end
end
