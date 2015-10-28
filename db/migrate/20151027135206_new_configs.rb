class NewConfigs < ActiveRecord::Migration
  def change
    PimsConfig.create(:property_name => "order_number_prefix" , :property_value => "PIMSO" , :description => "Order number prefix used in ordering more drugs from inventory page")
    PimsConfig.create(:property_name => "organization_name")
    PimsConfig.create(:property_name => "organization_address")
    PimsConfig.create(:property_name => "organization_contact_person")
    PimsConfig.create(:property_name => "organization_email")
    PimsConfig.create(:property_name => "organization_registration_number")
  end
end
