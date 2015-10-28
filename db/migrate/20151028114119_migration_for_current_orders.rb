class MigrationForCurrentOrders < ActiveRecord::Migration
  def change
    Order.where(:organization_name => nil).update_all(:organization_name => PimsConfig.find_by_property_name("organization_name").property_value ,
                                                      :organization_email => PimsConfig.find_by_property_name("organization_email").property_value,
                                                      :organization_address => PimsConfig.find_by_property_name("organization_address").property_value,
                                                      :organization_contact_person => PimsConfig.find_by_property_name("organization_contact_person").property_value,
                                                      :organization_registration_number => PimsConfig.find_by_property_name("organization_registration_number").property_value,

    )
  end
end
