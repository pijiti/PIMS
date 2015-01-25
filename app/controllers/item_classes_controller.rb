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
      if @item_class.save
        redirect_to item_classes_path
      else
        render :new
    end
  end


  def update
      if @item_class.update(item_class_params)
         redirect_to item_classes_path
      else
         render :edit
    end
  end


  def destroy
    @item_class.destroy
      redirect_to item_classes_path
  end

  private

    def set_item_class
      @item_class = ItemClass.find(params[:id])
    end

    def item_class_params
      params.require(:item_class).permit(:item_class_name)
    end
end
