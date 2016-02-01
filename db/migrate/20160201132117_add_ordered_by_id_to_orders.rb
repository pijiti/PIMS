class AddOrderedByIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ordered_by_id, :integer
  end
end
