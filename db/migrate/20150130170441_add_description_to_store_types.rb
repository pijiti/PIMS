class AddDescriptionToStoreTypes < ActiveRecord::Migration
  def change
  	add_column :store_types, :description, :text
  end
end
