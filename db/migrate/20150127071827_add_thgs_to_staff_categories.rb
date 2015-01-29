class AddThgsToStaffCategories < ActiveRecord::Migration
  def change
  	add_column :staff_categories, :description, :string
  end
end
