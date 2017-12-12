class ChangeColumnReturnDateToReturns < ActiveRecord::Migration
  def change
  	change_column :returns, :return_date, :datetime
  end
end
