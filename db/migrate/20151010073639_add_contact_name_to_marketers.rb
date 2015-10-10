class AddContactNameToMarketers < ActiveRecord::Migration
  def change
    add_column :marketers, :contact_name, :string
    add_column :marketers, :contact_mobile, :string
    add_column :marketers, :contact_email, :string
    add_column :marketers, :reg_number, :string
    add_column :marketers, :address, :text
  end
end
