class CreateLostDrugs < ActiveRecord::Migration
  def change
    create_table :lost_drugs do |t|
      t.string :lost_qty
      t.integer :receipt_id

      t.timestamps
    end
  end
end
