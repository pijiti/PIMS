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

    respond_to do |format|
      if @unit_dose.save
        format.html { redirect_to @unit_dose, notice: 'Unit dose was successfully created.' }
        format.json { render :show, status: :created, location: @unit_dose }
      else
        format.html { render :new }
        format.json { render json: @unit_dose.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @unit_dose.update(unit_dose_params)
        format.html { redirect_to @unit_dose, notice: 'Unit dose was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit_dose }
      else
        format.html { render :edit }
        format.json { render json: @unit_dose.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @unit_dose.destroy
    respond_to do |format|
      format.html { redirect_to unit_doses_url, notice: 'Unit dose was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_unit_dose
      @unit_dose = UnitDose.find(params[:id])
    end

    def unit_dose_params
      params.require(:unit_dose).permit(:unit_dose_name, :unit_dose_type)
    end
end
