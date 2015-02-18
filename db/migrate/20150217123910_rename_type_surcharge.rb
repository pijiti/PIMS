class RenameTypeSurcharge < ActiveRecord::Migration
  def change
  		rename_column :surcharges, :type, :charge_type
  end
end
