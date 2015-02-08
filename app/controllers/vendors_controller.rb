class VendorsController < ApplicationController
  before_action :set_vendor, only: [:show, :edit, :update, :destroy]


  def index
    @vendors = Vendor.all
    new
  end


  def new
    @vendor = Vendor.new
    @vendor_categories = VendorCategory.order("vendorcategory_name")
    @states = State.all
    @stores = Store.where(store_type_id:1)
  end


  def edit
  end


  def create
    @vendor = Vendor.new(vendor_params)
     #authorize @vendor
    @error = @vendor.errors.full_messages.to_sentence unless @vendor.save
  end


  def update
      if @vendor.update(vendor_params)
       redirect_to vendors_path
      else
        render :edit
    end
  end


  def destroy
    @vendor.destroy
      redirect_to vendors_path
  end

  private

    def set_vendor
      @vendor = Vendor.find(params[:id])
    end


    def vendor_params
      params.require(:vendor).permit(:name, :address,:reg_number,:state_id,:store_id,:contact_email, :contact_name, :contact_mobile,:vendor_category_id)
    end
end
