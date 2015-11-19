class MarketersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_marketer, only: [:show, :edit, :update, :destroy]

  def index
    @marketers = Marketer.all
     new
     respond_to do |format|
     	format.html
      format.xlsx
    end
  end

  def new
    @marketer = Marketer.new
  end

  def edit
  end

  def create
    @marketer = Marketer.new(marketer_params)

     begin
     	#authorize @marketer
      @marketer.save!
      rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
      rescue StandardError::Pundit::NotAuthorizedError => e
      @error = e.message
    end
  end

  def update
  	begin
     @marketer.attributes = marketer_params
     #authorize @marketer
    @marketer.save!
      rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end

  def destroy
  	begin
    #authorize  @marketer
    @marketer.destroy!
     rescue ActiveRecord::DeleteRestrictionError => e
   	@error = e.message
   end
  end

  private
    def set_marketer
      @marketer = Marketer.find(params[:id])
    end

    def marketer_params
      params.require(:marketer).permit(:name,:description,:foreign , :contact_name , :contact_mobile , :contact_email , :reg_number , :address)
    end
end
