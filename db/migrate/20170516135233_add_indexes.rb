class AddIndexes < ActiveRecord::Migration
  def change
    add_index :prescriptions, :patient_id
    add_index :prescriptions, [:updated_at , :status]
  end
end
