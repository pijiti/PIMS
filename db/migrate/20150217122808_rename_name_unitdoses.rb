class RenameNameUnitdoses < ActiveRecord::Migration
  def change
  	rename_column :unit_doses, :type, :form_type
  end
end
