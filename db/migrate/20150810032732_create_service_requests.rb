class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.integer :request_store_id
      t.integer :from_store_id
      t.float :qty
      t.integer :pharm_item_id

      t.timestamps
    end
  end
end
