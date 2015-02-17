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
    @item_class = ItemClass.create!(item_class_params)
    @error = @item_class.error.full_messages
  end


  def update
     @item_class.update!(item_class_params)
     @error = @item_class.error.full_messages
  end


  def destroy
    @item_class.destroy!
    @error = @item_class.error.full_messages
  end

  private

    def set_item_class
      @item_class = ItemClass.find(params[:id])
    end

    def item_class_params
      params.require(:item_class).permit(:name,:description)
    end
end
