class RemoveNameLocal < ActiveRecord::Migration
  def change
  	rename_column :hospital_units,  :hospital_unit_name, :name
  	rename_column :hospital_units,  :hospital_unit_description, :description
  	rename_column :item_classes,  :item_class_name, :name
  	rename_column :item_concentration_units, :conc_unit_name, :name
  	rename_column :locals, :local_name, :name
  	rename_column :marketers, :marketer_name, :name
  	rename_column :organisations, :organisation_name, :name
  	rename_column :patients, :patient_age, :age
		rename_column :patients, :patient_mobile, :mobile
		rename_column :patients, :patient_firstname, :firstname
		rename_column :patients, :patient_surname, :surname
		rename_column :patients, :patient_hospital_id, :hospital_number
		rename_column :pharm_items, :pharm_item_name, :name
		rename_column :prescriptions, :prescription_code, :code
		rename_column :staff_categories, :staff_category_name, :name
		rename_column :states, :state_name, :name
		rename_column :store_operations, :store_operation_name, :name
		rename_column :store_types, :store_type_name, :name
		rename_column :stores, :store_name, :name
		rename_column :stores, :store_location, :location
		rename_column :titles, :title_name, :name
		rename_column :unit_doses, :unit_dose_name, :name
		rename_column :unit_doses, :unit_dose_type, :type
  end
end
