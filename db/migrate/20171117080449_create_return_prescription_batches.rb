class CreateReturnPrescriptionBatches < ActiveRecord::Migration
  def change
    create_table :return_prescription_batches do |t|
      t.belongs_to :pharm_item, index: true
      t.belongs_to :brand, index: true
      t.string :qty
      t.string :rate
      t.belongs_to :prescription, index: true
      t.belongs_to :return, index: true

      t.timestamps
    end
  end
end
