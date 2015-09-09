class AddPrescriptionIdToPrescriptionBatches < ActiveRecord::Migration
  def change
    add_column :prescription_batches, :prescription_id, :integer
  end
end
