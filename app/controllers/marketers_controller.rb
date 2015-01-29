class MarketersController < ApplicationController
  before_action :set_marketer, only: [:show, :edit, :update, :destroy]

  skip_before_filter :authenticate_user!


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
      	flash[:notice] = "#{@marketer.marketer_name }" + " created in the PIMS! "
        redirect_to marketers_path
      else
      	flash[:error] = " The record was not created in the PIMS due to error.Try again. "
        render :new
    end
  end


  def update
      if @marketer.update(marketer_params)
      	flash[:notice] = "#{@marketer.marketer_name }" + " has been updated on the PIMS! "
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
