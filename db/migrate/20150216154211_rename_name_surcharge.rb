class RenameNameSurcharge < ActiveRecord::Migration
  def change
  	add_column :surcharges,  :name, :string
  	add_column :surcharge_items,  :name, :string
  	rename_column :surcharges, :surcharge_type, :type
  end
end
