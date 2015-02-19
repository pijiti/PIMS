class UnitDosesController < ApplicationController
  before_action :set_unit_dose, only: [:show, :edit, :update, :destroy]



  def index
    @unit_doses = UnitDose.all
    new
  end

  def new
    @unit_dose = UnitDose.new
  end


  def edit
  end


  def create
    @unit_dose = UnitDose.new(unit_dose_params)
    #authorize @unit_dose
    @error = @unit_dose.errors.full_messages.to_sentence unless @unit_dose.save!
  end


  def update
      @unit_dose.attributes = unit_dose_params
      #authorize @unit_dose
      @error = @unit_dose.errors.full_messages.to_sentence unless @unit_dose.save!
  end


  def destroy
  	#authorize @unit_dose
    @error = @unit_dose.errors.full_messages.to_sentence unless @unit_dose.destroy!
  end

  private

    def set_unit_dose
      @unit_dose = UnitDose.find(params[:id])
    end

    def unit_dose_params
      params.require(:unit_dose).permit(:name, :form_type)
    end
end
