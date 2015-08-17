class AddBrandIdToServiceRequests < ActiveRecord::Migration
  def change
    add_column :service_requests, :brand_id, :integer
  end
end
