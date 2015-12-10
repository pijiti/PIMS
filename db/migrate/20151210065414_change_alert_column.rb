class ChangeAlertColumn < ActiveRecord::Migration
  def change
    rename_column :alerts , :service_request_id , :order_id
  end
end
