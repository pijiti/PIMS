class AddTransferBatchesPrefix < ActiveRecord::Migration
  def change
    PimsConfig.create(:property_name => "transfer_batches_prefix" , :property_value => "PIMSTB" , :description => "Order prefix for transfer batches")
  end
end
