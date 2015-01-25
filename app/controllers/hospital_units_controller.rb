class HospitalUnitsController < ApplicationController
  before_action :set_hospital_unit, only: [:show, :edit, :update, :destroy]
  respond_to :html,:pdf,:js


  def index
    @hospital_units = HospitalUnit.paginate(:page => params[:page])
  end


  def new
    @hospital_unit = HospitalUnit.new
  end


  def edit
  end


  def create
    @hospital_unit = HospitalUnit.create!(hospital_unit_params)
  end


  def update
      @hospital_unit.update!(hospital_unit_params)
  end


  def destroy
    @hospital_unit.destroy!
  end

  private

    def set_hospital_unit
      @hospital_unit = HospitalUnit.find(params[:id])
    end

    def hospital_unit_params
      params.require(:hospital_unit).permit(:hospital_unit_name, :hospital_unit_description)
    end

end
