class AddLooseUnitsToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :loose_units, :decimal
  end
end
