class AddIndexesIbatches < ActiveRecord::Migration
  def change
    add_index :inventory_batches, :expired
    add_index :inventory_batches, :batch_id
    add_index :inventory_batches, :inventory_id
  end
end
