class PrescriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prescription, only: [:show, :edit, :update, :destroy, :complete_dispense, :print_pdf]


  def complete_dispense
    errors = []
    @prescription.prescription_batches.each do |p|
      p.collation_batches.each do |cb|
        if (cb.inventory_batch.units.to_i - cb.units.to_i) >= 0
          cb.inventory_batch.update(:units => cb.inventory_batch.units.to_i - cb.units.to_i)
        else
          errors << "Only #{cb.inventory_batch.units} units of  #{cb.inventory_batch.try(:batch).try(:brand).try(:name)} available."
        end
      end
    end

    if errors.blank? and @prescription.update(prescription_params)
      @prescription.update(:status => "DISPENSED")
      redirect_to dispense_prescriptions_path, :notice => "Prescription #{@prescription.code} has been dispensed successfully"
    else
      flash[:error] = errors.to_sentence
      flash[:error] << @prescription.errors.values.flatten.to_sentence if @prescription.errors
      redirect_to dispense_prescriptions_path
    end
  end

  def dispense
    @prescriptions = Prescription.includes(:prescription_batches, :doctor, :patient).where(:status => ["COLLATION COMPLETED", "DISPENSED"], :id => PrescriptionBatch.where(:store => current_store).pluck(:prescription_id).uniq).order('code DESC')
  end

  def collate
    @prescriptions = Prescription.includes(:prescription_batches, :doctor, :patient).where(:id => PrescriptionBatch.where(:store => current_store).pluck(:prescription_id).uniq).order('code DESC')
    @prescriptions.each do |prescription|
      prescription.prescription_batches.each do |p|
        next if !p.inventory_batches.blank?
        InventoryBatch.includes(:batch).where(:expired => nil, :inventory => Inventory.where(:brand_id => p.brand_id, :store => p.store)).each do |inventory_batch|
          next if inventory_batch.units.to_i == 0
          p.inventory_batches << inventory_batch
        end
      end
    end
  end

  def complete_collation
    logger.debug "=====#{params[:prescription_batch].symbolize_keys}======"
    @prescription_batch = PrescriptionBatch.find(params[:id])
    if @prescription_batch.update(prescription_batch_params)

      sum_units = 0
      @prescription_batch.collation_batches.each do |b|
        sum_units += b.units.to_i if b.units
      end
      if sum_units != @prescription_batch.qty.to_i
        redirect_to collate_prescriptions_path, :notice => "Quantity assigned does not match the billed quantity"
      else
        @prescription_batch.update(:approved => true)
        @prescription_batch.prescription.update(:status => "COLLATION COMPLETED") if @prescription_batch.prescription.prescription_batches.where(:approved => nil).blank?
        redirect_to collate_prescriptions_path, :notice => "Assigned the batch successfully"
      end

    else
      redirect_to collate_prescriptions_path, :notice => "Assigned the batch failed"
    end
  end

  def index
    b = Inventory.where(:store_id => current_store.try(:id) , :id => InventoryBatch.where.not(:units => 0).pluck(:inventory_id)).pluck(:brand_id)
    @brands = Brand.includes(:pharm_item).order('pharm_items.name ASC').where(:id => b)
    @patient_id = params[:patient_id]
    @prescriptions = Prescription.where(:patient_id => params[:patient_id]).order('code DESC')
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


  def print_pdf
    pdf = PrescriptionVoucher.new(@prescription, current_store, current_user)
    file = pdf.generate
    send_file file, filename: "pims_invoice.pdf", type: "application/pdf", disposition: "attachment"

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
      @prescription.total_calculation
      if @prescription.save
        flash[:prescription_created] = print_pdf_prescription_url(@prescription)
        format.html { redirect_to prescriptions_path(:patient_id => @prescription.patient_id), notice: 'Prescription was successfully created.' }
        # format.html{ redirect_to print_pdf_prescription_path(@prescription) }
      else
        @error = @prescription.errors.values.flatten
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
        flash[:prescription_created] = print_pdf_prescription_url(@prescription)
        format.html { redirect_to prescriptions_path(:patient_id => @prescription.patient_id), notice: 'Prescription was successfully updated.' }
        # format.html{ redirect_to print_pdf_prescription_path(@prescription) }
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
                                         prescription_batches_attributes: [:id, :store_id, :pharm_item_id, :brand_id, :rate, :qty, :batch_number, :comments, :approved, :_destroy],
    )
  end


  def prescription_batch_params
    params.require(:prescription_batch).permit(:id, :id, :store_id, :pharm_item_id, :brand_id, :rate, :qty, :batch_number, :comments, :approved, :_destroy, collation_batches_attributes: [:id, :batch_id, :inventory_batch_id, :units])
  end
end
