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
