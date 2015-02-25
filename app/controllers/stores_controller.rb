class StoresController < ApplicationController

  before_action :set_store, only: [:show, :edit, :update, :destroy]


  def index
    @stores = Store.all
    new
  end



  def new
    @store = Store.new
    @stores = Store.all
    #@roles = @store.roles.build
    @store_operations = StoreOperation.all
    @store_types = StoreType.all
  end


  def edit
  @stores = Store.all
  end


  def create

    begin
    @store = Store.new(store_params)
    #authorize @store
    params[:store][:role_ids].each do |role|
    @store.roles.build(:name => role)if role.present?
   end
   @store.save!
  rescue
  	   rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
     # rescue StandardError::Pundit::NotAuthorizedError => e
     # @error = e.message
   end
  end


  def update
     @store.attributes = store_params
     #authorize @store
     @error = @store.errors.full_messages.to_sentence unless @store.save!
  end

  def destroy
  	begin
  	#authorize @store
  	logger.debug"Logger Output for Store: #{@store.name}}"
    logger.debug"Logger Output for Roles for Store: #{@store.roles.collect{|i| i.name}}"
  	@store.destroy!
  	rescue StandardError::Pundit::NotAuthorizedError => e
    @error = e.message
   end
  end

  private

    def set_store
      @store = Store.find(params[:id])
    end


    def store_params
      params.require(:store).permit(:name, :store_type_id,:role_ids,:parent_store,:operation_mode, :open_time, :close_time,:parent_id,:store_operation_id)
    end
end
