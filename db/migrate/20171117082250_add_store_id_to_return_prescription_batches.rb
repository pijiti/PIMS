class AddStoreIdToReturnPrescriptionBatches < ActiveRecord::Migration
  def change
    add_reference :return_prescription_batches, :store, index: true
  end
end
