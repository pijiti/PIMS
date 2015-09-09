class AddDoctorIdToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :doctor_id, :integer
    add_column :prescriptions, :prescription_date, :datetime

  end
end
