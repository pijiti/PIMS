class MarkBatchesFromRampUp < ActiveRecord::Migration

  def change
    Batch.where(:supply_id => [false,nil]).update_all(:approval_status => "APPROVED")
  end

end
