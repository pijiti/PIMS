class AddSubtotalToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :subtotal, :string
    add_column :prescriptions, :total, :string
    add_column :prescriptions, :surcharges, :string
  end
end
