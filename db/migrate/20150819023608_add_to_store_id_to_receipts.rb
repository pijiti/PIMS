class AddToStoreIdToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :to_store_id, :integer
  end
end
