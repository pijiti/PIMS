class PrescriptionsController < ApplicationController

  before_action :set_prescription, only: [:show, :edit, :update, :destroy, :complete_dispense]


  def complete_dispense
    @prescription.prescription_batches.each do |p|
      p.collation_batches.each do |cb|
         cb.inventory_batch.update(:units => cb.inventory_batch.units.to_i - cb.units.to_i )
      end
    end

    @prescription.update(:comments => params[:prescription][:comments], :status => "DISPENSED")

    redirect_to dispense_prescriptions_path , :notice => "Prescription #{@prescription.code} has been dispensed successfully"
  end

  def dispense
    @prescriptions = Prescription.includes(:prescription_batches).order('updated_at ASC').where(:status => ["COLLATION COMPLETED", "DISPENSED"])
  end

  def collate
    @prescriptions = Prescription.includes(:prescription_batches  , :doctor , :patient).order('updated_at ASC').all
    @prescriptions.each do |prescription|
      prescription.prescription_batches.each do |p|
        next if !p.inventory_batches.blank?
        InventoryBatch.includes(:batch).where(:expired => nil, :inventory => Inventory.where(:brand_id => p.brand_id, :store => p.store)).each do |inventory_batch|
          next if inventory_batch.units.to_i == 0
          p.inventory_batches <<  inventory_batch
        end
      end
    end
  end

  def complete_collation
    logger.debug "=====#{params[:prescription_batch].symbolize_keys}======"
    @prescription_batch = PrescriptionBatch.find(params[:id])
    if @prescription_batch.update(prescription_batch_params)
      @prescription_batch.update(:approved => true)
      @prescription_batch.prescription.update(:status => "COLLATION COMPLETED") if  @prescription_batch.prescription.prescription_batches.where(:approved => nil).blank?
      redirect_to collate_prescriptions_path , :notice => "Assigned the batch successfully"
    else
      redirect_to collate_prescriptions_path , :notice => "Assigned the batch failed"
    end
  end

  def index

    @brands = Brand.includes(:pharm_item).order('pharm_items.name ASC').all
    @patient_id = params[:patient_id]
    @prescriptions = Prescription.where(:patient_id => params[:patient_id])
    @patient = Patient.find_by_id(@patient_id) if @patient_id
    new
    @all_prescriptions = Prescription.order(:created_at)
    respond_to do |format|
      format.html
      format.xlsx { render xlsx: "index", filename: "#{Time.zone.now}.xlsx" }
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
    @prescription = Prescription.new(:patient_id => @patient_id, :prescription_date => Time.now)
    1.times do
      @prescription.prescription_batches.build
    end
  end


  def edit
    @brands = Brand.includes(:pharm_item).order('pharm_items.name ASC').all
    @patient_id = params[:patient_id]
    @patient = Patient.find_by_id(@patient_id) if @patient_id
  end


  def create
    @prescription = Prescription.new(prescription_params)

    respond_to do |format|
      if @prescription.save
        format.html { redirect_to prescriptions_path(:patient_id => @prescription.patient_id), notice: 'Prescription was successfully created.' }
      else
        @error = @prescription.errors.full_messages
        flash[:error] = "#{@error.to_sentence}"

        @prescriptions = Prescription.where(:patient_id => @prescription.patient_id)
        @brands = Brand.includes(:pharm_item).order('pharm_items.name ASC').all
        @patient_id = @prescription.patient_id
        @patient = Patient.find_by_id(@patient_id) if @patient_id
        @all_prescriptions = Prescription.order(:created_at)
        format.html { render 'index' }
        #format.html { redirect_to prescriptions_path(:patient_id => @prescription.patient_id) }
      end
    end
  end


  def update
    respond_to do |format|
      params[:prescription][:total] = @prescription.total_calculation
      puts prescription_params
      if @prescription.update(prescription_params)
        format.html { redirect_to prescriptions_path(:patient_id => @prescription.patient_id), notice: 'Prescription was successfully updated.' }
      else
        @error = @prescription.errors.full_messages
        flash[:error] = "#{@error.to_sentence}"

        @brands = Brand.includes(:pharm_item).order('pharm_items.name ASC').all
        @patient_id = params[:patient_id]
        @prescriptions = Prescription.where(:patient_id => @patient_id)
        @patient = Patient.find_by_id(@patient_id) if @patient_id
        @all_prescriptions = Prescription.order(:created_at)

        format.html { render :index }
      end
    end
  end


  def destroy
    @prescription.destroy
    respond_to do |format|
      format.html { redirect_to prescriptions_path(:patient_id => @prescription.patient_id), notice: 'Prescription was successfully destroyed.' }
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
    params.require(:prescription).permit(:user_id, :hospital_unit_id, :patient_id, :code, :doctor_id, :prescription_date, :subtotal, :surcharges_name, :surcharges, :total,
                                         prescription_batches_attributes: [:id, :store_id, :pharm_item_id, :brand_id, :rate, :qty, :batch_number, :comment, :approved, :_destroy] ,
                                         )
  end


  def prescription_batch_params
    params.require(:prescription_batch).permit(:id , :id, :store_id, :pharm_item_id, :brand_id, :rate, :qty, :batch_number, :comment, :approved, :_destroy , collation_batches_attributes: [:id, :batch_id , :inventory_batch_id , :units ])
  end
end
