class SuppliesController < ApplicationController
  before_action :authenticate_user!

  # rescue_from ActiveRecord::RecordNotFound, with:  :invalid_supplier
  before_action :set_supply, only: [:edit, :update, :destroy, :submit, :approval]
  before_action :set_all_supplies, only: [:index, :create, :update, :destroy]
  #before_action :set_store, only: [:new,:index]
  respond_to :html, :js, :csv


  def filter_expired_drugs
    from_store = params[:inventory_batch][:store_id]
    generic_drug = params[:inventory_batch][:pharm_item_id]
    batch_id = params[:inventory_batch][:batch_number]
    if can? :manage, :all
      @inventory_batches = InventoryBatch.includes(:inventory, :batch).where(:expired => true)
      @batches = Batch.all.order('batch_number ASC').pluck(:batch_number, :id)
    else
      InventoryBatch.includes(:inventory, :batch).where(:inventory => current_store.inventories, :expired => true)
      @batches = Batch.where(:id => @inventory_batches.pluck(:id)).order('batch_number ASC').pluck(:batch_number, :id)
    end

    @inventory_batches = @inventory_batches.includes(:inventory, :batch).where(:inventory => Store.find(from_store).inventories) if !from_store.blank?
    @inventory_batches = @inventory_batches.includes(:inventory, :batch).where(:batch => Batch.where(:pharm_item_id => generic_drug)) if !generic_drug.blank?
    @inventory_batches = @inventory_batches.includes(:inventory, :batch).where(:batch_id => batch_id) if !batch_id.blank?

    @stores = Store.all
    @filter = InventoryBatch.new
    @pharm_items = PharmItem.all

  end

  #filter transfer of drugs
  def filter_transfer_drugs

    #admin can see all service requests
    from_store = params[:inventory_batch][:store_id]
    generic_drug = params[:inventory_batch][:pharm_item_id]
    @inventory_batches = ""
    @stores = Store.all
    if can? :manage, :all
      @inventory_batches = InventoryBatch.includes(:inventory, :batch).where(:expired => nil)

    else
      @inventory_batches = InventoryBatch.includes(:inventory, :batch).where(:inventory => current_store.inventories, :expired => nil)
    end
    @inventory_batches = @inventory_batches.includes(:inventory, :batch).where(:inventory => Store.find(from_store).inventories) if !from_store.blank?
    @inventory_batches = @inventory_batches.includes(:inventory, :batch).where(:batch => Batch.where(:pharm_item_id => generic_drug)) if !generic_drug.blank?
    @pharm_items = PharmItem.all
    @filter = ServiceRequest.new

  end

  #from sidebar
  def expired_drugs
    from_store = params[:store_id]
    generic_drug = params[:pharm_item_id]
    batch_id = params[:batch_id]
    alert_id = params[:alert_id]

    if can? :manage, :all
      @inventory_batches = InventoryBatch.includes(:inventory, :batch).where(:expired => true)
      @batches = Batch.all.pluck(:batch_number, :id)
    else
      InventoryBatch.includes(:inventory, :batch).where(:inventory => current_store.inventories, :expired => true)
      @batches = Batch.where(:id => @inventory_batches.pluck(:id)).pluck(:batch_number, :id)
    end
    @inventory_batches = @inventory_batches.includes(:inventory, :batch).where(:inventory => Store.find(from_store).inventories) if !from_store.blank?
    @inventory_batches = @inventory_batches.includes(:inventory, :batch).where(:batch => Batch.where(:pharm_item_id => generic_drug)) if !generic_drug.blank?
    @inventory_batches = @inventory_batches.includes(:inventory, :batch).where(:batch_id => batch_id) if !batch_id.blank?

    #update alert id status
    if !batch_id.blank? and !alert_id.blank?
      Alert.find_by_id(alert_id).update(:status => "READ")
    end

    @stores = Store.all
    @filter = InventoryBatch.new(:store_id => from_store, :batch_number => batch_id)
    @pharm_items = PharmItem.all
  end

  #from sidebar
  def transfer_drugs
    if can? :manage, :all
      @inventory_batches = InventoryBatch.includes(:inventory, :batch).where(:expired => nil)
    else
      @inventory_batches = InventoryBatch.includes(:inventory, :batch).where(:inventory => current_store.inventories, :expired => nil)
    end
    @stores = Store.all
    @filter = InventoryBatch.new
    @pharm_items = PharmItem.all
  end

  def transfer_batches_v2
    params[:supply][:batches_attributes].each do |k, v|
      next if v[:allot].blank?
      i = InventoryBatch.find_by_id(v[:inventory_batch_id])
      i.allot = v[:allot]
      flash[:notice] = i.allotment(v[:transfer_to_store])
    end

    if flash[:notice] and flash[:notice].include? "Success"
      flash[:notice] = "Batch of drugs transferred successfully"
    else
      flash[:notice]= "Please enter number of drugs to transfer"
    end

    redirect_to transfer_drugs_supplies_path
  end

  #transfer of batches based on allotment. service request page
  def transfer_batches
    counter = 0
    s = ServiceRequest.find_by_id(params[:supply][:service_request_id])

    if params[:supply][:batches_attributes].blank?
      flash[:notice]= "Please select the batches for allocation"
      redirect_to service_request_supplies_path and return
    end
    params[:supply][:batches_attributes].each do |k, v|
      counter += v[:allot].to_i
    end

    if counter == s.qty.to_i
      params[:supply][:batches_attributes].each do |k, v|
        next if v[:allot].blank?
        i = InventoryBatch.find_by_id(v[:inventory_batch_id])
        i.allot = v[:allot]
        flash[:notice] = i.allotment(v[:store_id], s.id)
      end
      if flash[:notice] and flash[:notice].include? "Success"
        s.update(:status => "AWAITING DELIVERY CONFIRMATION")
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
    alert = params[:alert]
    if !alert.blank?
      a = Alert.find_by_id(alert)
      a.update(:status => "READ")
      @service_requests = [a.service_request]
    end

    if can? :manage, :all
      @service_requests ||= ServiceRequest.includes(:pharm_item, :request_store, :from_store).all.order("status DESC , order_id ASC")
      @stores = Store.all
    else
      @service_requests ||= ServiceRequest.includes(:pharm_item, :request_store, :from_store).where(:request_store => current_store).order("status DESC ,order_id DESC")
      @stores = Store.where(:id => current_store.id)
    end


    @pharm_items = PharmItem.all
    @filter = ServiceRequest.new(:status => "ALL")
  end


  def filter_service_requests
    from_store = params[:service_request][:from_store_id]
    generic_drug = params[:service_request][:pharm_item_id]
    requests_from = params[:service_request][:created_at]
    status = params[:service_request][:status]

    @service_requests = ""
    if can? :manage, :all
      @service_requests = ServiceRequest.includes(:pharm_item, :request_store, :from_store).all.order("status DESC , order_id ASC")
      @stores = Store.all
    else
      @service_requests = ServiceRequest.includes(:pharm_item, :request_store, :from_store).where(:request_store => current_store).order("status DESC , order_id ASC")
      @stores = Store.where(:id => current_store.id)
    end
    @service_requests = @service_requests.includes(:pharm_item, :request_store).where(:from_store_id => from_store) if !from_store.blank?
    @service_requests = @service_requests.includes(:pharm_item, :request_store).where(:pharm_item_id => generic_drug) if !generic_drug.blank?
    @service_requests = @service_requests.includes(:pharm_item, :request_store).where("created_at > ?", Time.strptime(requests_from, "%d/%m/%Y")) if !requests_from.blank?
    @service_requests = @service_requests.includes(:pharm_item, :request_store).where(:status => status) if !status.blank? and status != "ALL"
  end

  #order when drug stock is less. ordered for dispensary store
  def order
    s = Store.find_by_id(params[:supply][:store_id])
    ps = Store.find_by_id(params[:supply][:parent_store_id])
    p = PharmItem.find_by_id(params[:supply][:pharm_item_id])
    b = Brand.find_by_id(params[:supply][:brand_id])
    qty = params[:supply][:order_qty]
    order = params[:supply][:order_number]
    if Order.where(:id => order).blank?
      logger.debug "============order blank========="
      o = Order.create(:number => "#{PimsConfig.find_by_property_name('order_number_prefix').property_value}-#{1000 + Order.all.count}")
      order = o.id
    end

    #create service request
    sr = ServiceRequest.create(:from_store => s, :request_store => ps, :qty => qty, :pharm_item => p, :brand => b, :order_id => order)

    User.with_any_role({:name => "Store Manager", :resource => ps}, {:name => "Store Keeper", :resource => ps}).each do |u|
      #create alerts
      Alert.create(:store => ps, :user => u, :status => "UNREAD", :service_request => sr, :alert_type => "ORDER", :message => "#{b.try(:name).try(:capitalize)} brand of drug #{p.try(:name)} of quantity #{qty} has been requested from #{ps.name}")

      if u.email and Rails.env == "production"
        begin
          UserMailer.delay.order_from_central_store(u, qty, p, s, b).deliver
            #send_sms(u.username, "Hello #{u.first_name},Drug #{p.name} has been requested from #{s.name}")
        rescue => e
          ExceptionNotifier.notify_exception(e)
        end
      end
    end

    redirect_to inventory_index_path, :notice => "Notified the central store"
  end

  def index
    if can? :manage, :all
      @supplies = Supply.includes(:batches).order("created_at desc").all
    else
      @supplies = Supply.includes(:batches).where(:store => current_store).order("created_at desc")
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
            i.update(:qty_last_added => batch.qty.to_f * batch.brand.pack_size.to_f, :rate_per_unit => "%.2f" % (batch.rate / batch.brand.pack_size.to_f))

            #check if batch number already exists
            b = InventoryBatch.where(:batch_id => Batch.where(:batch_number => batch.batch_number).pluck(:id), :inventory => i).first
            if b.blank?
              InventoryBatch.create(:inventory => i, :batch => batch, :units => batch.qty.to_i * batch.brand.pack_size.to_i)
            else
              logger.debug "======Inventory batch exists with same batch number========="
              b.update(:units => b.units.to_i + (batch.qty.to_i * batch.brand.pack_size.to_i))
            end
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
        begin
          UserMailer.delay.approval_alert(user, @supply).deliver if Rails.env == "production"
        rescue => e
          ExceptionNotifier.notify_exception(e)
        end
        #sms notification
        send_sms(user.username, "Hello #{user.first_name}, You have an invoice with reference - #{@supply.invoice_reference} waiting for approval.")
        recipients_counter += 1
      end
      flash[:notice] = "Submitted for approval. Mail and sms notification dispatched to #{recipients_counter} recipients"
      redirect_to supplies_path
    end
  end


  def new
    @supply = Supply.new(:store => current_store)
    @marketers = Marketer.order('name ASC').all

    #Users with any of the 3 roles for current store
    @users = User.with_any_role("Admin", {:name => "Store Keeper", :resource => current_store}, {:name => "Store Manager", :resource => current_store})

    @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%MAIN STORE%")).pluck(:name, :id)

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
    @marketers = Marketer.order('name ASC').all
    @users = User.all
    @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%MAIN STORE%")).pluck(:name, :id)
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
      @marketers = Marketer.order('name ASC').all

      #Users with any of the 3 roles for current store
      @users = User.with_any_role("Admin", {:name => "Store Keeper", :resource => current_store}, {:name => "Store Manager", :resource => current_store})
      @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%MAIN STORE%")).pluck(:name, :id)

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
        @marketers = Marketer.order('name ASC').all
        @users = User.all
        @central_stores = Store.where(:store_type => StoreType.where("upper(name) like ?", "%MAIN STORE%")).pluck(:name, :id)
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
    params.require(:supply).permit(:marketer_id, :invoice_reference, :invoice_date, :invoice_value, :signed_off_by, :user_id, :store_id, :approval_status, :approved, :approved_by, :_destroy, :approval_type,
                                   batches_attributes: [:id, :pharm_item_id, :brand_id, :rate, :qty, :batch_number, :mfd_date, :expiry_date, :comments, :approved, :recipient_store, :giver_store, :_destroy, :selector])
  end

  def invalid_supplier
    logger.error "Attempt to access invalid supplier #{params[:id]}"
    redirect_to supplies_path, notice: 'Invalid Supplier'
  end

end
