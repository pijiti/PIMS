class StaffCategoriesController < ApplicationController
  load_and_authorize_resource
  # before_action :set_staff_category, only: [:show, :edit, :update, :destroy]


  def index
    @staff_categories = StaffCategory.all
    new
     respond_to do |format|
     	  format.html
        format.xlsx
    end
  end



  def new
    @staff_category = StaffCategory.new
  end


  def edit
  end


  def create
    @staff_category = StaffCategory.new(staff_category_params)
    begin
     #authorize @staff_category
     @staff_category.save!
    rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def update
      @staff_category.attributes = staff_category_params
      begin
      #authorize @staff_category
      @staff_category.save!
       rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
      end
  end


  def destroy
  	begin
    #authorize @staff_category
    @staff_category.destroy!
    rescue ActiveRecord::DeleteRestrictionError => e
   	@error = e.message
   	end
  end

  private

    def set_staff_category
      @staff_category = StaffCategory.find(params[:id])
    end


    def staff_category_params
      params.require(:staff_category).permit(:name,:description)
    end
end
