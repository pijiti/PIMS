class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :brand_id
      t.integer :store_id
      t.integer :units

      t.timestamps
    end
  end
end
