class MarketersController < ApplicationController
  before_action :set_marketer, only: [:show, :edit, :update, :destroy]


  def index
    @marketers = Marketer.all
     new
  end


  def new
    @marketer = Marketer.new
  end

  def edit
  end


  def create
    @marketer = Marketer.new(marketer_params)
      if @marketer.save
        redirect_to marketers_path
      else
        render :new
    end
  end


  def update
      if @marketer.update(marketer_params)
        redirect_to marketers_path
      else
         render :edit
    end
  end

  def destroy
    @marketer.destroy
       redirect_to marketers_path
  end

  private
    def set_marketer
      @marketer = Marketer.find(params[:id])
    end

    def marketer_params
      params.require(:marketer).permit(:marketer_name,:description,:foreign)
    end
end
