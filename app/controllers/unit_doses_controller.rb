class UnitDosesController < ApplicationController
  before_action :set_unit_dose, only: [:show, :edit, :update, :destroy]



  def index
    @unit_doses = UnitDose.all
    new
    respond_to do |format|
     	format.html
      format.xlsx
    end
  end

  def new
    @unit_dose = UnitDose.new
  end


  def edit
  end


  def create
    @unit_dose = UnitDose.new(unit_dose_params)
    begin
    #authorize @unit_dose
    @unit_dose.save!
    rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def update
      @unit_dose.attributes = unit_dose_params
      begin
      #authorize @unit_dose
     @unit_dose.save!
     rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def destroy
  	begin
  	#authorize @unit_dose
    @unit_dose.destroy!
    rescue ActiveRecord::DeleteRestrictionError => e
   	@error = e.message
   end
  end

  private

    def set_unit_dose
      @unit_dose = UnitDose.find(params[:id])
    end

    def unit_dose_params
      params.require(:unit_dose).permit(:name, :form_type)
    end
end
