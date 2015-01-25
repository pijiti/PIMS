class AddNokToPatients < ActiveRecord::Migration
  def change
  	add_column :patients, :nok_name, :string
  	add_column :patients, :nok_mobile, :string
  end
end
