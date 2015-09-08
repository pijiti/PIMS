class AddPrefix < ActiveRecord::Migration
  def change
    p = PimsConfig.find_by_property_name("prescription_prefix")
    if p.blank?
      PimsConfig.create(:property_name => "prescription_prefix", :property_value => "PIMS", :description => "Prescription prefix on the prescriptions. The prefix together with trailing number makes up the unique identifier for each prescription")
    end
  end
end
