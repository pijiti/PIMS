class AddGenderToPatients < ActiveRecord::Migration
  def change
  	remove_column :patients, :gender_id
  	add_column :patients, :gender, :integer, default: 0, null: false
  end
end
