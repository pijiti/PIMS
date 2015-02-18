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
    authorize @staff_category
    @error = @staff_category.errors.full_messages.to_sentence unless @staff_category.save!
  end


  def update
      @staff_category.attributes = staff_category_params
      authorize @staff_category
      @error = @staff_category.errors.full_messages.to_sentence unless @staff_category.save!
  end


  def destroy
    authorize @staff_category
    @error = @staff_category.errors.full_messages.to_sentence unless @staff_category.destroy!
  end

  private

    def set_staff_category
      @staff_category = StaffCategory.find(params[:id])
    end


    def staff_category_params
      params.require(:staff_category).permit(:name,:description)
    end
end
