class AddStatusToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :status, :string
  end
end
