class AddDescritpionToItemConcentrationUnit < ActiveRecord::Migration
  def change
  	add_column :item_concentration_units, :description, :string
  end
end
