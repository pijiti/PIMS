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
    @staff_category = StaffCategory.create!(staff_category_params)
    @error = @staff_category.error.full_messages
  end


  def update
      @staff_category.update!(staff_category_params)
      @error = @staff_category.error.full_messages
  end


  def destroy
    @staff_category.destroy!
    @error = @staff_category.error.full_messages
  end

  private

    def set_staff_category
      @staff_category = StaffCategory.find(params[:id])
    end


    def staff_category_params
      params.require(:staff_category).permit(:name,:description)
    end
end
