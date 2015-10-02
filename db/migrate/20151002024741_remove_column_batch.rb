class RemoveColumnBatch < ActiveRecord::Migration
  def change
    remove_column :prescription_batches , :batch_id
  end
end
