class AddCommentsToPrescriptionBatches < ActiveRecord::Migration
  def change
    add_column :prescription_batches, :comments, :text
  end
end
