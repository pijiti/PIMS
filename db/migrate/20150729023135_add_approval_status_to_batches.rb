class AddApprovalStatusToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :approval_status, :string  , default: "PENDING APPROVAL"
  end
end
