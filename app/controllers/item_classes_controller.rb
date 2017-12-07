class ItemClassesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  # before_action :set_item_class, only: [:show, :edit, :update, :destroy]


  def index
    @item_classes = ItemClass.includes(:sub_classes).all
    new
    respond_to do |format|
      format.html
      format.xlsx
    end
  end


  def new
    @item_class = ItemClass.new
    @item_class.sub_classes.build
  end


  def edit
    @item_class.sub_classes.build
  end


  def create
    @item_class = ItemClass.new(item_class_params)
    begin
      #authorize @item_class
      @item_class.save!
    rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def update
    begin
      @item_class.attributes = item_class_params
      #authorize @item_class
      @item_class.save!
    rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def destroy
    begin
      #authorize  @item_class
      @item_class.destroy!
    rescue ActiveRecord::DeleteRestrictionError => e
      @error = e.message
    end
  end

  private

  def set_item_class
    @item_class = ItemClass.find(params[:id])
  end

  def item_class_params
    params.require(:item_class).permit(:name, :description,
                                       sub_classes_attributes: [:id, :name, :description, :_destroy])

  end
end
