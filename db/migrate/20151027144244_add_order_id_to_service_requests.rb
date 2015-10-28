class AddOrderIdToServiceRequests < ActiveRecord::Migration
  def change
    add_column :service_requests, :order_id, :integer
  end
end
