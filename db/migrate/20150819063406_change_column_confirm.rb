class ChangeColumnConfirm < ActiveRecord::Migration
  def change
    change_column :receipts, :confirm_receipt , :string
  end
end
