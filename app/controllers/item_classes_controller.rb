class ItemClassesController < ApplicationController
  before_action :set_item_class, only: [:show, :edit, :update, :destroy]


  def index
    @item_classes = ItemClass.all
     new
  end


  def new
    @item_class = ItemClass.new
  end


  def edit
  end


  def create
    @item_class = ItemClass.new(item_class_params)
    authorize @item_class
    @error = @item_class.errors.full_messages.to_sentence unless @item_class.save!
  end


  def update
     @item_class.attributes = item_class_params
     authorize @item_class
     @error = @item_class.errors.full_messages.to_sentence unless @item_class.save!
  end


  def destroy
     authorize  @item_class
    @error = @item_class.error.full_messages.to_sentence unless  @item_class.destroy!
  end

  private

    def set_item_class
      @item_class = ItemClass.find(params[:id])
    end

    def item_class_params
      params.require(:item_class).permit(:name,:description)
    end
end
