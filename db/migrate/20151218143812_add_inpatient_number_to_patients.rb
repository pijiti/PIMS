class AddInpatientNumberToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :inpatient_number, :string
  end
end
