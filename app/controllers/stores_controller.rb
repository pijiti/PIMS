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
    #@store.roles << Role.find(params[:store][:role_ids].select{|i| i.present? })
    #authorize @store
    params[:store][:role_ids].each do |role_id|
    	logger.debug "#{role_id}"
    @store.roles.build(:name => role_id)unless role.blank?
  @store.save!
   end
  end


  def update
     @store.attributes = store_params
     #authorize @store
     @error = @store.errors.full_messages.to_sentence unless @store.save!
  end

  def destroy
  	authorize @store
    @error = @store.error.full_messages.to_sentence unless  @store.destroy!
  end

  private

    def set_store
      @store = Store.find(params[:id])
    end


    def store_params
      params.require(:store).permit(:name, :store_type_id,{:role_ids => []},:parent_store,:operation_mode, :open_time, :close_time,:parent_id,:store_operation_id)
    end
end
