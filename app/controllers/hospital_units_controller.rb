class HospitalUnitsController < ApplicationController
  before_action :set_hospital_unit, only: [:show, :edit, :update, :destroy]
  respond_to :html,:pdf,:js


  def index
    @hospital_units = HospitalUnit.all
    new
  end


  def new
    @hospital_unit = HospitalUnit.new
  end


  def edit
  end


  def create
    @hospital_unit = HospitalUnit.create!(hospital_unit_params)
    @error = @hospital_unit.error.full_messages
  end


  def update
      @hospital_unit.update!(hospital_unit_params)
      @error = @hospital_unit.error.full_messages
  end


  def destroy
    @hospital_unit.destroy!
    @error = @hospital_unit.error.full_messages
  end

  private

    def set_hospital_unit
      @hospital_unit = HospitalUnit.find(params[:id])
    end

    def hospital_unit_params
      params.require(:hospital_unit).permit(:name, :description)
    end

end
