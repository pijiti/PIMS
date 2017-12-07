class AddApprovedToReturns < ActiveRecord::Migration
  def change
    add_column :returns, :approved, :boolean, default: false
  end
end
