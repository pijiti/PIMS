class AddMarketerIdToSupplies < ActiveRecord::Migration
  def change
    add_column :supplies, :marketer_id, :integer
  end
end
