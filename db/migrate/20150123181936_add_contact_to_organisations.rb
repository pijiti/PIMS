class AddContactToOrganisations < ActiveRecord::Migration
  def change
  	add_column :organisations, :contact_phone,:string
  	add_column :organisations, :contact_email, :string
  end
end
