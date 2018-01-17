class ReturnsController < ApplicationController
  before_action :set_return, only: [:edit, :update, :destroy]

  # GET /returns
  # GET /returns.json
  def index
    @returns = Return.all
  end

  # # GET /returns/1
  # # GET /returns/1.json
  def show
    @prescription = Prescription.find_by_id(params[:id])
    @return = Return.where(prescription_id: params[:id])
  end

  # GET /returns/new
  def new
    @prev_return = Return.where(prescription_id: params[:id])
    @return = Return.new(prescription_id: params[:id] , user_id: current_user.id)
    @prescription = Prescription.find_by_id(params[:id])
    @prescription.prescription_batches.each do |pb|
      return_prescription_batch = @return.return_prescription_batches.new(prescription_batch_id: pb.id, pharm_item_id: pb.pharm_item_id, brand_id: pb.brand_id, rate: pb.rate , prescription_id: @prescription.id)
      pb.collation_batches.each do |cb|
        return_prescription_batch.return_collation_batches.new(collation_batch_id: cb.id, prescription_batch_id: cb.prescription_batch_id, inventory_batch_id: cb.inventory_batch_id)
      end
    end

    @brands = Brand.includes(:pharm_item).order('pharm_items.name ASC').where(:id => @prescription.prescription_batches.pluck(:brand_id))
  end

  # # GET /returns/1/edit
  # def edit
  # end

  # POST /returns
  # POST /returns.json
  def create
    @return = Return.new(return_params)
    @return.user_id = current_user.try(:id)
    @return.store_id = current_store.try(:id)
    @return.return_date = Time.now
    respond_to do |format|
      if @return.save
        format.html { redirect_to return_path(id: @return.prescription), notice: 'Return was successfully processed.' }
        # format.html { redirect_to return_prescriptions_path, notice: 'Return was successfully processed.' }
        format.json { render :show, status: :created, location: @return }
      else
        format.html { render :new }
        format.json { render json: @return.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /returns/1
  # PATCH/PUT /returns/1.json
  def update
    respond_to do |format|
      if @return.update(return_params)
        format.html { redirect_to @return, notice: 'Return was successfully updated.' }
        format.json { render :show, status: :ok, location: @return }
      else
        format.html { render :edit }
        format.json { render json: @return.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def return_approval_index
    authorize! :return_approval, @return_approvals
    if !filter_return_params.blank?
      @filter_return = Return.new(filter_return_params)
      logger.debug "=== from_date : #{from_date = @filter_return.from_date}"
      logger.debug "=== to_date : #{last_date = @filter_return.to_date}"
      logger.debug "=== return_status : #{return_status = @filter_return.return_status}"
      @return_approvals = Return.where("created_at >= ? and created_at <= ?", from_date.to_date, last_date.to_date)
      if !return_status.blank?
        if return_status == "All"
          @return_approvals = Return.all if @return_approvals.blank?
        else  
          @return_approvals = @return_approvals.blank? ? Return.where(approved: (return_status == "Approved")) : @return_approvals.where(approved: (return_status == "Approved"))
        end
      end      
    else
      @filter_return = Return.new
      @return_approvals = Return.where(approved: false)
      Alert.find(params[:alert_id]).update(status: "READ") if params[:alert_id].present?
    end
  end

  def approve_return
    return_row = Return.find(params[:id])
    authorize! :return_approval, return_row
    return_row.return_prescription_batches.each do |rpb|
      rpb.return_collation_batches.each do |rcb|
        inv_batch = rcb.inventory_batch
        logger.debug "=== [BEFORE]inv_batch_units : #{inv_batch.units}"
        inv_batch.update(units: (inv_batch.units + rcb.units.to_i))
        logger.debug "=== [AFTER]inv_batch_units : #{inv_batch.units}"
      end
    end
    return_row.update(approved: true)
    redirect_to return_approval_index_returns_path
  end

  # # DELETE /returns/1
  # # DELETE /returns/1.json
  # def destroy
  #   @return.destroy
  #   respond_to do |format|
  #     format.html { redirect_to returns_url, notice: 'Return was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_return
      @return = Return.find(params[:id])
    end

    def filter_return_params
      params.require(:return).permit(:return_status , :from_date , :to_date) if params.has_key?(:return)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def return_params
      # params.require(:return).permit(:prescription_id, :subtotal, :total, :surcharges, :return_date, :user_id, :store_id, return_collation_batches_attributes: [:id, :brand_id , :qty, :rate , :pharm_item_id, :prescription_id, :_destroy, return_prescription_batches_attributes: [:id, :return_prescription_batch_id, :collation_batch_id, :prescription_batch_id, :inventory_batch_id, :units]])
      params.require(:return).permit(:prescription_id, :store_id, :subtotal, :total, :surcharges, :return_date, :user_id, :store_id, return_prescription_batches_attributes: [:prescription_batch_id, :id, :store_id, :brand_id , :qty, :rate , :pharm_item_id, :prescription_id, :_destroy, return_collation_batches_attributes: [:id, :return_prescription_batch_id, :collation_batch_id, :prescription_batch_id, :inventory_batch_id, :units]])
    end
end