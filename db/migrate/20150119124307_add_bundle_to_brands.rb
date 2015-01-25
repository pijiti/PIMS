class AddBundleToBrands < ActiveRecord::Migration
  def change
  	add_column :brands, :pack_bundle, :integer
  end
end
