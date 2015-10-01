class AddBatchIdToPrescriptionBatches < ActiveRecord::Migration
  def change
    add_column :prescription_batches, :batch_id, :integer
  end
end
