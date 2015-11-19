class UpdateAlert < ActiveRecord::Migration
  def change
    Alert.all.update_all(:alert_type => "EXPIRY")
  end
end
