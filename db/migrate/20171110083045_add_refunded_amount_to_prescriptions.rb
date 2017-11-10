class AddRefundedAmountToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :refunded_amount, :string , default: "0"
  end
end
