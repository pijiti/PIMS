class AddIndexesPbatches < ActiveRecord::Migration
  def change
    add_index :batches, :brand_id
    add_index :batches, :pharm_item_id
    add_index :batches, :prescription_id

    add_index :prescription_batches, :store_id
    add_index :prescription_batches, :pharm_item_id
    add_index :prescription_batches, :brand_id
    add_index :prescription_batches, :prescription_id


    add_index :inventories, :store_id
    add_index :inventories, :brand_id
    add_index :inventories, :pharm_item_id


  end
end
