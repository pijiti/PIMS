class RenameColumnBatch < ActiveRecord::Migration
  def change
    rename_column :collation_batches , :prescripton_batch_id , :prescription_batch_id
  end
end
