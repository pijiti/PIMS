class BatchesController < ApplicationController
  before_action :set_all_batches, only: [:index]
  before_action  :set_batch , only: [:destroy]

  def index
  end

  def ramp_up
    @batch = Batch.new
    @brands = Brand.includes(:pharm_item, :item_concentration_unit, :unit_dose , :marketer).order('name ASC').all
    @batches = Batch.includes(:brand).all
  end

  #Back door creation. Ramp up batches
  def create
    old_batch = Batch.find_by_batch_number(batch_params[:batch_number])
    #if batch number exists, just update store and qty
    if old_batch
      @batch = old_batch
      @batch.qty = batch_params[:qty]
      @batch.recipient_store = batch_params[:recipient_store]
    else
      @batch = Batch.new(batch_params)
    end

    begin
      if @batch.save
        i = Inventory.where(:brand_id => @batch.brand_id, :store_id => @batch.recipient_store).first

        if i.blank?
          #create inventory.
          i = Inventory.create(:brand => @batch.brand, :store_id => @batch.recipient_store, :pharm_item => @batch.brand.pharm_item)
        end

        i.update(:qty_last_added => @batch.qty.to_f * @batch.brand.pack_size.to_f, :rate_per_unit => "%.2f" % (@batch.rate / @batch.brand.pack_size.to_f))
        ibatches = i.inventory_batches.where(:batch => @batch)
        if ibatches.blank?
          InventoryBatch.create(:inventory => i, :batch => @batch, :units => @batch.qty.to_i * @batch.brand.pack_size.to_i)
        else
          ibatches.first.update(:units => (ibatches.first.units) +  (@batch.qty.to_i* @batch.brand.pack_size.to_i) )
        end


        redirect_to ramp_up_batches_path, :notice => "Batch created successfully"
      else
        redirect_to ramp_up_batches_path, :notice => "Batch creation failed"
      end
    rescue => e
      redirect_to ramp_up_batches_path, :notice => "Batch creation failed. #{e.message}"
    end
  end

  def destroy
    if @batch.destroy
      redirect_to ramp_up_batches_path, :notice => "Batch deleted successfully"
    else
      redirect_to ramp_up_batches_path, :notice => "Batch deletion failed"
    end
  end

  private

  def set_batch
    @batch = Batch.find(params[:id])
  end

  def set_all_batches
    @batches = Batch.all
  end

  def batch_params
    params.require(:batch).permit(:pharm_item_id, :brand_id, :rate, :qty, :batch_number, :mfd_date, :expiry_date, :comments, :approved, :recipient_store, :giver_store, :_destroy, :selector, :approval_status)
  end

end
