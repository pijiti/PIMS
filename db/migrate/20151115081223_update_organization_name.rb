class UpdateOrganizationName < ActiveRecord::Migration
  def change
    PimsConfig.find_by_property_name("organization_name").update(:property_value => "State Specialist Hospital,Ondo")
  end
end
