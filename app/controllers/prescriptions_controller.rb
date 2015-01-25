class PrescriptionsController < ApplicationController

	before_action :set_prescription, only: [:show, :edit, :update, :destroy]

  def index
   @prescriptions = Prescription.paginate(:page => params[:page])
   @all_prescriptions = Prescription.order(:created_at)
   respond_to  do  |format|
   	  format.html
      format.xlsx {render xlsx: "index", filename: "#{Time.zone.now}.xlsx"}
      format.pdf do
        pdf = PrescriptionPdf.new(@all_prescriptions)
        send_data pdf.render, filename: "#{Time.zone.now}.pdf", type: 'application/pdf'
      end
    end
  end

  def search
 @prescriptions = Prescription.params[:query]
   render new
  end


  def show

  end


  def new
    @prescription = Prescription.new
		3.times  do
     	    @prescription.batches.build
     end
  end


  def edit

  end


  def create
    @prescription = Prescription.new(prescription_params)

    respond_to do |format|
      if @prescription.save
        format.html { redirect_to prescriptions_path, notice: 'Prescription was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end


  def update
    respond_to do |format|
      if @prescription.update(prescription_params)
        format.html { redirect_to prescriptions_url, notice: 'Prescription was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy
    @prescription.destroy
    respond_to do |format|
      format.html { redirect_to prescriptions_path , notice: 'Prescription was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:patient_id])
    end

    def set_prescription
     @prescription = Prescription.find(params[:id])
    end


    def prescription_params
      params.require(:prescription).permit(:user_id, :hospital_unit_id,:patient_id,:prescription_code,
                                                                 batches_attributes: [:id,:pharm_item_id,:brand_id,:rate,:qty, :batch_number,:comment,:approved])
    end
end
