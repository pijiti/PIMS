class AddMinDispensableBrands < ActiveRecord::Migration
  def change
  	add_column :brands, :min_dispensable, :decimal, precision: 5,scale: 2
  end
end
