class CreateReturnCollationBatches < ActiveRecord::Migration
  def change
    create_table :return_collation_batches do |t|
      t.integer :return_prescription_batch_id
      t.integer :collation_batch_id
      t.integer :prescription_batch_id
      t.integer :inventory_batch_id
      t.string :units

      t.timestamps
    end
  end
end
