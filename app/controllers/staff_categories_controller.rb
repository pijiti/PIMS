class StaffCategoriesController < ApplicationController
  before_action :set_staff_category, only: [:show, :edit, :update, :destroy]


  def index
    @staff_categories = StaffCategory.all
    new
  end



  def new
    @staff_category = StaffCategory.new
  end


  def edit
  end


  def create
    @staff_category = StaffCategory.new(staff_category_params)
      if @staff_category.save
         redirect_to staff_categories_path
      else
       redirect_to staff_categories_path
    end
  end


  def update
      if @staff_category.update(staff_category_params)
        redirect_to staff_categories_path
      else
       redirect_to staff_categories_path
    end
  end


  def destroy
    @staff_category.destroy
    redirect_to staff_categories_path
  end

  private

    def set_staff_category
      @staff_category = StaffCategory.find(params[:id])
    end


    def staff_category_params
      params.require(:staff_category).permit(:staff_category_name,:description)
    end
end
