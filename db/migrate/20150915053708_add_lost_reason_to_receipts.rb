class AddLostReasonToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :lost_reason, :string
    add_column :receipts, :comments, :text
  end
end
