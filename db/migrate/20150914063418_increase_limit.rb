class IncreaseLimit < ActiveRecord::Migration
  def change
    change_column :marketers, :name , :text , :limit => 250
    change_column :marketers, :description , :text , :limit => 1500

    change_column :vendors, :name , :text , :limit => 250
    change_column :vendors, :address , :text , :limit => 1500


  end
end
