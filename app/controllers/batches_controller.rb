class BatchesController < ApplicationController
  before_action :set_all_batches, only: [:index]

  def index
  end

  private

    def set_batch
      @batch = Batch.params[:id]
    end

    def set_all_batches
    	@batches = Batch.all
    end

    def batch_params
      params.require(:batch).permit(:Qty, :Rate, :subtotal, :supply_id,:expiry_date , :mfd_date)
    end

end
