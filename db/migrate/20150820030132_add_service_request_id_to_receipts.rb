class AddServiceRequestIdToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :service_request_id, :integer
  end
end
