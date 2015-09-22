class AddSurchargesNameToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :surcharges_name, :string
  end
end
