class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.text :message
      t.integer :store_id
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
