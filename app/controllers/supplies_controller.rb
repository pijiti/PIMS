class SuppliesController < ApplicationController


  # rescue_from ActiveRecord::RecordNotFound, with:  :invalid_supplier
  before_action :set_supply, only: [:edit, :update, :destroy, :submit, :approval]
  before_action :set_all_supplies, only: [:index, :create, :update, :destroy]
  #before_action :set_store, only: [:new,:index]
  respond_to :html, :js, :csv

  #from sidebar
  def transfer_drugs
    @inventory_batches = InventoryBatch.includes(:inventory,:batch).all
    @stores = Store.all
    @filter = InventoryBatch.new
  end

  #transfer of batches based on allotment
  def transfer_batches
    counter = 0
    s = ServiceRequest.find_by_id(params[:supply][:service_request_id])

    params[:supply][:batches_attributes].each do |k, v|
      counter += v[:allot].to_i
    end

    if counter == s.qty.to_i
      params[:supply][:batches_attributes].each do |k, v|
        next if v[:allot].blank?
        i = InventoryBatch.find_by_id(v[:inventory_batch_id])
        i.allot = v[:allot]
        flash[:notice] = i.allotment(v[:store_id])
      end
      if flash[:notice] and flash[:notice].include? "success"
        s.update(:status => "COMPLETED")
      else
        flash[:notice]= "Please select the batches for allocation"
      end
    else
      flash[:notice] = "Quantity alloted does not match with the request. Please try again"
    end

    redirect_to service_request_supplies_path
  end

  #central store services requests from dispensary store
  def service_request
    #admin can see all service requests
    if can? :manage, :all
      @service_requests = ServiceRequest.includes(:pharm_item, :request_store , :from_store).all.order("status DESC")
      @stores = Store.all
    else
      @service_requests = ServiceRequest.includes(:pharm_item, :request_store , :from_store).where(:request_store => current_store).order("status DESC")
      @stores = Store.where(:id => current_store.id)
    end
    @pharm_items = PharmItem.all
    @filter = ServiceRequest.new
  end


  def filter_service_requests
    from_store = params[:service_request][:from_store_id]
    generic_drug = params[:service_request][:pharm_item_id]
    @service_requests = ""
    if can? :manage, :all
      @service_requests = ServiceRequest.includes(:pharm_item, :request_store, :from_store).all.order("status DESC")
      @stores = Store.all
    else
      @service_requests = ServiceRequest.includes(:pharm_item, :request_store, :from_store).where(:request_store => current_store).order("status DESC")
      @stores = Store.where(:id => current_store.id)
    end
    @service_requests = @service_requests.includes(:pharm_item, :request_store).where(:from_store_id =>  from_store) if !from_store.blank?
    @service_requests = @service_requests.includes(:pharm_item, :request_store).where(:pharm_item_id =>  generic_drug) if !generic_drug.blank?
  end

  #order when drug stock is less. ordered for dispensary store
  def order
    s = Store.find_by_id(params[:supply][:store_id])
    ps = Store.find_by_id(params[:supply][:parent_store_id])
    p = PharmItem.find_by_id(params[:supply][:pharm_item_id])

    #create service request
    ServiceRequest.create(:from_store => s, :request_store => ps, :qty => params[:supply][:order_qty], :pharm_item => p)

    User.with_any_role({:name => "Store Manager", :resource => ps}, {:name => "Store Keeper", :resource => ps}).each do |u|
      if u.email
        UserMailer.order_from_central_store(u, params[:supply][:order_qty], p, s).deliver
      end
    end

    redirect_to inventory_index_path, :notice => "Notified the central store"
  end

  def index
    if can? :manage  , :all
      @supplies = Supply.all.order("created_at desc")
    else
      @supplies = Supply.where(:store => current_store).order("created_at desc")
    end
    new
  end


  def search

  end

  #Approval from the approval page.
  def approval

    @notice = "Please select before approving/rejecting"
    approval_status = ""
    begin
      if supply_params[:approval_type] == "approve"
        supply_params[:batches_attributes].each do |k, v|

          next if v[:selector] != "1"
          Batch.update(v[:id], :approval_status => "APPROVED", :comments => v[:comments])
          @notice = "Selected batches approved"
          approval_status = "approved"
          # update inventory
          batch = Batch.find(v[:id])
          i = Inventory.where(:brand_id => batch.brand_id, :store_id => @supply.store_id).first
          if i
            i.update( :qty_last_added => batch.qty.to_f * batch.brand.pack_size.to_f, :rate_per_unit => batch.rate / batch.brand.pack_size.to_f)
            InventoryBatch.create(:inventory => i, :batch => batch, :units =>  batch.qty.to_i * batch.brand.pack_size.to_i)
          end
        end
      elsif supply_params[:approval_type] == "reject"
        supply_params[:batches_attributes].each do |k, v|
          next if v[:selector] != "1"
          if v[:comments].blank?
            @notice = "Please enter the reason for rejection in comments"
          else
            Batch.update(v[:id], :approval_status => "REJECTED", :comments => v[:comments])
            @notice = "Selected batches rejected"
            approval_status = "rejected"
          end
        end
      end
      @supply.update_approval_status
      if ["approved", "rejected"].include? approval_status
        #send sms
        sms_to = User.find_by_id(@supply.signed_off_by)
        send_sms(sms_to.username, "Hello #{sms_to.first_name}, the batch of drugs with reference - #{@supply.invoice_reference} has been #{approval_status}.") if sms_to
      end
    rescue => e
      @notice = e.message
    end

    flash[:notice] = @notice

    redirect_to approval_index_approvals_path

  end

  def submit
    if @supply.try(:batches).try(:empty?)
      redirect_to unit_doses_path
    else
      @supply.submit_for_approval

      #mail notification
      recipients_counter = 0
      User.with_any_role({:name => "Store Manager", :resource => current_store}).each do |user|
        UserMailer.approval_alert(user, @supply).deliver
        #sms notification
        send_sms(user.username, "Hello #{user.first_name}, You have an invoice with reference - #{@supply.invoice_reference} waiting for approval.")
        recipients_counter += 1
      end


      @supplies = Supply.where(:store => current_store)
      new
      flash[:notice] = "Submitted for approval. Mail and sms notification dispatched to #{recipients_counter} recipients"
      render "supplies/index"
    end
  end


  def new
    @supply = Supply.new(:store => current_store)
    @vendors = Vendor.all

    #Users with any of the 3 roles for current store
    @users = User.with_any_role("Admin", {:name => "Store Keeper", :resource => current_store}, {:name => "Store Manager", :resource => current_store})

    @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%CENTRAL%")).pluck(:name, :id)

    1.times do
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
    #(10-@supply.batches.try(:count)).times do
    #  @supply.batches.build
    #end
  end


  def create
    @supply = Supply.new(supply_params)
    @supply.assign_recipient_store
    @supply.assign_pharmitem_id
    if @supply.save
      flash[:notice] = "Batches of drugs saved successfully"
      redirect_to supplies_path
    else
      @error = @supply.errors.full_messages
      flash[:error] = "#{@error.to_sentence}"
      @supplies = Supply.where(:store => current_store)
      @vendors = Vendor.all

      #Users with any of the 3 roles for current store
      @users = User.with_any_role("Admin", {:name => "Store Keeper", :resource => current_store}, {:name => "Store Manager", :resource => current_store})
      @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%CENTRAL%")).pluck(:name, :id)

      #(10-@supply.batches.try(:count)).times do
      #  @supply.batches.build
      #end

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
      @supply.assign_pharmitem_id
      if @supply.update_attributes(supply_params)
        flash[:notice] = "Batches of drugs updated successfully"
        redirect_to supplies_path
      else
        logger.info("=========!!!!!!!!!!!!!!!!!!!!!!!================")
        logger.info(@supply.errors.messages.inspect)
        @vendors = Vendor.all
        @users = User.all
        @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%CENTRAL%")).pluck(:name, :id)
        render "supplies/edit"
      end
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
    params.require(:supply).permit(:vendor_id, :invoice_reference, :invoice_date, :invoice_value, :signed_off_by, :user_id, :store_id, :approval_status, :approved, :approved_by, :_destroy, :approval_type,
                                   batches_attributes: [:id, :pharm_item_id, :brand_id, :rate, :qty, :batch_number, :mfd_date, :expiry_date, :comments, :approved, :recipient_store, :giver_store, :_destroy, :selector])
  end

  def invalid_supplier
    logger.error "Attempt to access invalid supplier #{params[:id]}"
    redirect_to supplies_path, notice: 'Invalid Supplier'
  end

end
