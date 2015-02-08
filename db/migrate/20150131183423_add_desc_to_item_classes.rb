class AddDescToItemClasses < ActiveRecord::Migration
  def change
  	add_column :item_classes, :description, :text
  end
end
