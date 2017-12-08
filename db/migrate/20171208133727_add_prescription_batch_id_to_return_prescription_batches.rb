class AddPrescriptionBatchIdToReturnPrescriptionBatches < ActiveRecord::Migration
  def change
    add_column :return_prescription_batches, :prescription_batch_id, :integer
  end
end
