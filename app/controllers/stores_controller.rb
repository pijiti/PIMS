class StoresController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  # before_action :set_store, only: [:show, :edit, :update, :destroy]

  #set active store from topbar
  def set_active_store
    session[:active_store] = params[:store][:active_store]
    flash[:notice] = "#{current_store.try(:name)} store set as active store"
    redirect_to dashboard_path
  end

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
    respond_to do |format|
      format.html
      format.csv { send_data @stores.to_csv }
      format.xls { send_data @stores.to_csv(col_sep: "\t") }
    end
  end


  def edit
    @stores = Store.all
  end


  def create
    @store = Store.new(store_params)

    if @store.save
      flash[:notice] = "#{@store.name} store created successfully"
      redirect_to stores_path
    else
      @stores = Store.all
      @store_operations = StoreOperation.all
      @store_types = StoreType.all
      flash[:notice] = "#{@store.name} store creation failed"
      render "stores/index"
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
      logger.debug "Logger Output for Store: #{@store.name}}"
      logger.debug "Logger Output for Roles for Store: #{@store.roles.collect { |i| i.name }}"
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
    params.require(:store).permit(:name, {:store_roles => []}, :store_type_id, {:role_ids => []}, :parent_store, :operation_mode, :open_time, :close_time, :parent_id, :store_operation_id)
  end
end
