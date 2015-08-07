class CreateInventoryBatches < ActiveRecord::Migration
  def change
    create_table :inventory_batches do |t|
      t.integer :inventory_id
      t.integer :batch_id

      t.timestamps
    end
  end
end
