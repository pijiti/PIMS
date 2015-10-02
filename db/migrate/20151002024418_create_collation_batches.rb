class CreateCollationBatches < ActiveRecord::Migration
  def change
    create_table :collation_batches do |t|
      t.integer :prescripton_batch_id
      t.integer :batch_id
      t.string :units

      t.timestamps
    end
  end
end
