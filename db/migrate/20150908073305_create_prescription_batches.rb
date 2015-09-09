class CreatePrescriptionBatches < ActiveRecord::Migration
  def change
    create_table :prescription_batches do |t|
      t.integer :pharm_item_id
      t.integer :brand_id
      t.string :rate
      t.string :qty
      t.string :batch_number
      t.text :comment
      t.boolean :approved

      t.timestamps
    end
  end
end
