class AddStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders , :status , :string , default: "ORDER_INCOMPLETE"
    Order.all.update_all(:status => "ORDER_COMPLETE")
  end
end
