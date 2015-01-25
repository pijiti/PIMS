class AddLastDisapprovedToSupplies < ActiveRecord::Migration
  def change
  	add_column :supplies, :last_disapproved, :timestamp
  end
end
