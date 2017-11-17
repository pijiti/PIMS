class CreateReturns < ActiveRecord::Migration
  def change
    create_table :returns do |t|
      t.belongs_to :prescription, index: true
      t.float :subtotal
      t.float :total
      t.float :surcharges
      t.date :return_date
      t.integer :user_id

      t.timestamps
    end
  end
end
