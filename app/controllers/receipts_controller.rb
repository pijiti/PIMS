class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]


  def filter
    from_store = params[:receipt][:from_store_id]
    to_store = params[:receipt][:to_store_id]
    pharm_item = params[:receipt][:pharm_item_id]
    requests_from = params[:receipt][:created_at]
    status = params[:receipt][:confirm_receipt]

    if can? :manage, :all
      @receipts = Receipt.includes(:inventory, :from_store, :batch).all
    else
      @receipts = Receipt.includes(:inventory, :from_store, :batch).where(:to_store_id => current_store.id).all
    end

    @receipts = @receipts.includes(:inventory, :from_store, :batch).where(:from_store_id => from_store) if !from_store.blank?
    @receipts = @receipts.includes(:inventory, :from_store, :batch).where(:inventory => Inventory.where(:pharm_item_id => pharm_item)) if !pharm_item.blank?
    @receipts = @receipts.includes(:inventory, :from_store, :batch).where(:to_store_id => to_store) if !to_store.blank?
    @receipts = @receipts.includes(:inventory, :from_store, :batch).where("created_at > ?", Time.strptime(requests_from, "%d/%m/%Y")) if !requests_from.blank?
    @receipts = @receipts.includes(:inventory, :from_store, :batch).where(:confirm_receipt => status) if !status.blank? and status != "ALL"

  end

  def confirm
    @receipt = Receipt.find_by_id(params[:receipt][:id])
    if params[:receipt][:received_qty] and params[:receipt][:received_qty].to_i <= @receipt.qty and params[:receipt][:received_qty].to_i > -1

      if @receipt.update(:received_qty => params[:receipt][:received_qty] , :lost_reason => params[:receipt][:lost_reason] , :comments => params[:receipt][:comments])
        #lost some drugs in transit
        if @receipt.qty.to_i > @receipt.received_qty.to_i
          LostDrug.create(:receipt =>  @receipt, :lost_qty => @receipt.qty.to_i - @receipt.received_qty.to_i  )
        end

        @receipt.post_confirm_receipt(params[:receipt][:received_qty])
        flash[:notice] = "Batch number #{@receipt.batch.try(:batch_number)} has been received and added to the inventory of #{@receipt.to_store.try(:name)}"
      else
        @error = @receipt.errors.full_messages
        flash[:error] = "#{@error.to_sentence}"
      end


    else
      flash[:notice] = "Please check the value of received quantity"
    end

    redirect_to receipts_path
  end

  #
  def lost_drugs
    @lost_drugs = LostDrug.includes(:receipt , receipt: [:from_store , :to_store , batch: [:brand ] ]).all
  end

  # GET /receipts
  # GET /receipts.json
  def index
    if can? :manage, :all
      @receipts = Receipt.includes(:inventory, :from_store, :batch).all
    else
      @receipts = Receipt.includes(:inventory, :from_store, :batch).where(:to_store_id => current_store.id).all
    end
    @filter = Receipt.new(:confirm_receipt => "ALL")
    @stores = Store.all
    @pharm_items = PharmItem.all
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
  end

  # POST /receipts
  # POST /receipts.json
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to @receipt, notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url, notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_receipt
    @receipt = Receipt.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def receipt_params
    params.require(:receipt).permit(:batch_id, :inventory_id, :from_store_id, :qty, :confirm_receipt, :received_qty)
  end
end
