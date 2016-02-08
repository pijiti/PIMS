class VendorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vendor, only: [:show, :edit, :update, :destroy]


  def index
    @vendors = Vendor.all
    new
    respond_to do |format|
     	format.html
      format.xlsx
    end
  end


  #order for restocking central stores
  def order
    s = Store.find_by_id(params[:marketer][:store_id])
    p = PharmItem.find_by_id(params[:marketer][:pharm_item_id])
    Marketer.where(:id => params[:marketer][:id]).each do |v|
      begin
        UserMailer.delay.order_from_vendors(p, s ,v) if Rails.env == "production"
        # send_sms(v.contact_mobile, "Please contact the Pharmacist in charge of PMP stores,SSH,Ondo on matters relating to the #{p.name} ")   if v.contact_mobile and v.contact_name
      rescue => e
        ExceptionNotifier.notify_exception(e)
      end
    end

    redirect_to inventory_index_path , :notice => "Notified the vendors"
  end


  def new
    @vendor = Vendor.new
    @vendor_categories = VendorCategory.order(:name)
    @states = State.all
  end


  def edit
  	@vendor_categories = VendorCategory.order(:name)
    @states = State.all
  end


  def create
    @vendor = Vendor.new(vendor_params)
    begin
     #authorize @vendor
     @vendor.save!
      rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def update
   @vendor.attributes = vendor_params
   begin
    #authorize @vendor
  @vendor.save!
      rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def destroy
  	begin
  	#authorize @vendor
     @vendor.destroy!
      rescue ActiveRecord::DeleteRestrictionError => e
   	@error = e.message
   end
  end

  private

    def set_vendor
      @vendor = Vendor.find(params[:id])
    end


    def vendor_params
      params.require(:vendor).permit(:name, :address,:reg_number,:state_id,:store_id,:contact_email, :contact_name, :contact_mobile,:vendor_category_id)
    end
end
