class CreatePimsConfigs < ActiveRecord::Migration
  def change
    create_table :pims_configs do |t|
      t.string :property_name
      t.string :property_value
      t.text :description

      t.timestamps
    end
  end
end
