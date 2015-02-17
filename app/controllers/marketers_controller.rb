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
    @marketer = Marketer.create!(marketer_params)
     @error = @marketer.error.full_messages
  end

  def update
     @marketer.update!(marketer_params)
     @error = @marketer.error.full_messages
  end

  def destroy
    @marketer.destroy!
    @error = @marketer.error.full_messages
  end

  private
    def set_marketer
      @marketer = Marketer.find(params[:id])
    end

    def marketer_params
      params.require(:marketer).permit(:name,:description,:foreign)
    end
end
