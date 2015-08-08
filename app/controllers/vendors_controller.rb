class VendorsController < ApplicationController
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

    s = Store.find_by_id(params[:vendor][:store_id])
    p = PharmItem.find_by_id(params[:vendor][:pharm_item_id])
    Vendor.where(:id => params[:vendor][:id]).each do |v|
      UserMailer.order_from_vendors(p, s ,v).deliver
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
