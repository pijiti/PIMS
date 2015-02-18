class RenameNameVendorcategory < ActiveRecord::Migration
  def change
  	rename_column :vendor_categories, :vendorcategory_name, :name
  end
end
