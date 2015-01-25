class AddDescToMarketers < ActiveRecord::Migration
  def change
  	add_column :marketers, :description, :text
  	add_column :marketers, :foreign, :boolean, null: false, default: false
  end
end
