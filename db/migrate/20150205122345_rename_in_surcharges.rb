class RenameInSurcharges < ActiveRecord::Migration
  def change
  	rename_column :countries, :countries_name, :name
  end
end
