class SuppliesController < ApplicationController


  # rescue_from ActiveRecord::RecordNotFound, with:  :invalid_supplier
  before_action :set_supply, only: [:edit, :update, :destroy, :submit]
  before_action :set_all_supplies, only: [:index, :create, :update, :destroy]
  #before_action :set_store, only: [:new,:index]
  respond_to :html, :js, :csv


  def index
    @supplies = Supply.where(:store => current_store)
    new
  end


  def search

  end

  def submit
    if @supply.try(:batches).try(:empty?)
      redirect_to unit_doses_path
    else
      @supply.submit!
      redirect_to supplies_path
    end
  end


  def new
    @supply = Supply.new(:store => current_store)
    @vendors = Vendor.all

    #Users with any of the 3 roles for current store
    @users = User.with_any_role("Admin", {:name => "Store Keeper", :resource => current_store}, {:name => "Store Manager", :resource => current_store})

    @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%CENTRAL%")).pluck(:name, :id)

    10.times do
      @supply.batches.build
    end
  end

  def show_form
    new
  end

  def hide_form
  end


  def edit
    #current_store = Store.find(session[:active_store])
    @vendors = Vendor.all
    @users = User.all
    @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%CENTRAL%")).pluck(:name, :id)
    10.times do
      @supply.batches.build
    end
  end


  def create
    @supply = Supply.new(supply_params)
    @supply.assign_recipient_store
    @supply.assign_pharmitem_id
    if @supply.save
      redirect_to supplies_path
    else
      @error = @supply.errors.full_messages
      flash[:error] = "#{@error.to_sentence}"
      @supplies = Supply.where(:store => current_store)
      @vendors = Vendor.all

      #Users with any of the 3 roles for current store
      @users = User.with_any_role("Admin", {:name => "Store Keeper", :resource => current_store}, {:name => "Store Manager", :resource => current_store})
      @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%CENTRAL%")).pluck(:name, :id)

      (10-@supply.batches.try(:count)).times do
        @supply.batches.build
      end

      render "supplies/index"
    end #if @supply.amount_check?
  end


  def update
    if params[:commit] == 'Save and Approve'
      @supply.update_attributes(supply_params)
      @supply.save_and_approve(current_user.id)
      redirect_to users_path
    elsif params[:commit] == 'Disapprove'
      @supply.disapprove
      redirect_to marketers_path
    elsif params[:commit] == 'Save'
      @supply.update_attributes(supply_params)
      redirect_to hospital_units_path
    else
      @supply.update_attributes(supply_params)
      redirect_to supplies_path
    end
  end


  def destroy
    @supply.destroy
    @supplies = Supply.where(:store => current_store)
  end

  def routing_error(error = 'Routing error', status = :not_found, exception=nil)
    render_exception(404, "Routing Error", exception)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_supply
    @supply = Supply.find(params[:id])
  end

  def set_all_supplies
    @supplies = Supply.order(created_at: :desc).where(store_id: session[:active_store])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def supply_params
    params.require(:supply).permit(:vendor_id, :invoice_reference, :invoice_date, :invoice_value, :signed_off_by, :user_id, :store_id, :approval_status, :approved, :approved_by,
                                   batches_attributes: [:id, :pharm_item_id, :brand_id, :rate, :qty, :batch_number, :mfd_date, :expiry_date, :comment, :approved, :recipient_store, :giver_store])
  end

  def invalid_supplier
    logger.error "Attempt to access invalid supplier #{params[:id]}"
    redirect_to supplies_path, notice: 'Invalid Supplier'
  end

end
