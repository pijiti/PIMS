class StoresController < ApplicationController

  before_action :set_store, only: [:show, :edit, :update, :destroy]


  def index
    @stores = Store.all
    new
  end



  def new
    @store = Store.new
    @stores = Store.all
    @store.roles.build
  end


  def edit
  @stores = Store.all
  end


  def create
    @store = Store.new(store_params)
    params[:store][:role_ids].each do |role|
    @store.roles.build(:name => role)unless role.blank?
    end
      if @store.save
        redirect_to stores_path
      else
        render :new
    end
  end


  def update
      if @store.update(store_params)
        redirect_to stores_path
      else
        render :edit
    end
  end

  def destroy
    @store.destroy
      redirect_to stores_url
  end

  private

    def set_store
      @store = Store.find(params[:id])
    end


    def store_params
      params.require(:store).permit(:store_name, :store_location, :store_type_id, :role_id,:parent_store,:operation_mode, :open_time, :close_time,:parent_id,:store_operation_id)
    end
end
