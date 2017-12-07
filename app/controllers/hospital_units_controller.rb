class HospitalUnitsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :set_hospital_unit, only: [:show, :edit, :update, :destroy]
  respond_to :html,:pdf,:js


  def index
    @hospital_units = HospitalUnit.all
    new
    respond_to do |format|
     	format.html
      format.xlsx
    end
  end


  def new
    @hospital_unit = HospitalUnit.new
  end


  def edit
  end


  def create
    @hospital_unit = HospitalUnit.new(hospital_unit_params)
    begin
    #authorize @hospital_unit
    @hospital_unit.save!
   rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def update
      @hospital_unit.attributes = hospital_unit_params
      begin
      #authorize  @hospital_unit
       @hospital_unit.save!
        rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    end
  end


  def destroy
  	begin
   #authorize  @hospital_unit
    @hospital_unit.destroy!
    rescue ActiveRecord::DeleteRestrictionError => e
   	@error = e.message
   end
  end

  private

    def set_hospital_unit
      @hospital_unit = HospitalUnit.find(params[:id])
    end

    def hospital_unit_params
      params.require(:hospital_unit).permit(:name, :description)
    end

end
