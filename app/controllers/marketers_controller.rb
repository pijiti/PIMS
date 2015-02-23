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

     begin
     	authorize @marketer
      @marketer.save!
      rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
      rescue StandardError::Pundit::NotAuthorizedError => e
      @error = e.message
    end
  end

  def update
     @marketer.attributes = marketer_params
     #authorize @marketer
     @error = @marketer.errors.full_messages.to_sentence unless @marketer.save!
  end

  def destroy
    #authorize  @marketer
    @error = @marketer.errors.full_messages.to_sentence unless @marketer.destroy!
  end

  private
    def set_marketer
      @marketer = Marketer.find(params[:id])
    end

    def marketer_params
      params.require(:marketer).permit(:name,:description,:foreign)
    end
end
