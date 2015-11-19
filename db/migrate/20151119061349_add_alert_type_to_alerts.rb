class AddAlertTypeToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :alert_type, :string
  end
end
