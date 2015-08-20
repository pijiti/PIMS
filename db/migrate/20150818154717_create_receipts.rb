class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.integer :batch_id
      t.integer :inventory_id
      t.integer :from_store_id
      t.integer :qty
      t.boolean :confirm_receipt
      t.integer :received_qty

      t.timestamps
    end
  end
end
