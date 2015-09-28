class AddStoreIdToPrescriptionBatches < ActiveRecord::Migration
  def change
    add_column :prescription_batches, :store_id, :integer
  end
end
