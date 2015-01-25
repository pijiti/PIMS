class AddDisForBatches < ActiveRecord::Migration
  def change
  	add_column :batches, :dispensable_qty, :decimal, precision: 8, scale: 2
  	add_column :batches, :retail_price, :decimal, precision: 8, scale: 2
  end
end
