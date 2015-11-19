class AddServiceRequestIdToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :service_request_id, :integer
  end
end
