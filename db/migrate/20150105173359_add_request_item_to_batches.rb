class AddRequestItemToBatches < ActiveRecord::Migration
  def change
  	add_column :batches, :request_item_id, :integer
  end
end
