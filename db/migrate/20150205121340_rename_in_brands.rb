class RenameInBrands < ActiveRecord::Migration
  def change
  	rename_column :brands, :brand_name, :name
  	rename_column :vendors, :vendor_name, :name
  end
end
