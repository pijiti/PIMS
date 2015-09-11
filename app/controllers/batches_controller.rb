class BatchesController < ApplicationController
  before_action :set_all_batches, only: [:index]

  def index
  end

  def ramp_up
    @batch = Batch.new
  end

  def create
    @batch = Batch.new(batch_params)
    begin
      if @batch.save
        i = Inventory.where(:brand_id => @batch.brand_id, :store_id => @batch.recipient_store).first

        if i.blank?
          #create inventory.
          i = Inventory.create(:brand => @batch.brand, :store_id => @batch.recipient_store, :pharm_item => @batch.brand.pharm_item)
        end

        i.update(:qty_last_added => @batch.qty.to_f * @batch.brand.pack_size.to_f, :rate_per_unit => "%.2f" % (@batch.rate / @batch.brand.pack_size.to_f))
        InventoryBatch.create(:inventory => i, :batch => @batch, :units => @batch.qty.to_i * @batch.brand.pack_size.to_i)

        redirect_to ramp_up_batches_path, :notice => "Batch created successfully"
      else
        redirect_to ramp_up_batches_path, :notice => "Batch creation failed"
      end
    rescue => e
      redirect_to ramp_up_batches_path, :notice => "Batch creation failed. #{e.message}"
    end
  end

  private

  def set_batch
    @batch = Batch.params[:id]
  end

  def set_all_batches
    @batches = Batch.all
  end

  def batch_params
    params.require(:batch).permit(:pharm_item_id, :brand_id, :rate, :qty, :batch_number, :mfd_date, :expiry_date, :comments, :approved, :recipient_store, :giver_store, :_destroy, :selector, :approval_status)
  end

end
