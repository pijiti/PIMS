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
    @return = Return.where(prescription_id: params[:id])
  end

  # GET /returns/new
  def new
    @prev_return = Return.find_by_prescription_id(params[:id])
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
        format.html { redirect_to return_prescriptions_path, notice: 'Return was successfully processed.' }
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
    @return_approvals = Return.where(approved: false)
    authorize! :return_approval, @return_approvals
  end

  def approve_return
    return_row = Return.find(params[:id])
    authorize! :return_approval, return_row
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def return_params
      params.require(:return).permit(:prescription_id, :subtotal, :total, :surcharges, :return_date, :user_id, :store_id, return_collation_batches_attributes: [:id, :brand_id , :qty, :rate , :pharm_item_id, :prescription_id, :_destroy, return_prescription_batches_attributes: [:id, :return_prescription_batch_id, :collation_batch_id, :prescription_batch_id, :inventory_batch_id, :units]])
    end
end