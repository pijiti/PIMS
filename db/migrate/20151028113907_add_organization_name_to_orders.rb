class AddOrganizationNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :organization_name, :string
    add_column :orders, :organization_address, :text
    add_column :orders, :organization_contact_person, :string
    add_column :orders, :organization_email, :string
    add_column :orders, :organization_registration_number, :string
  end
end
