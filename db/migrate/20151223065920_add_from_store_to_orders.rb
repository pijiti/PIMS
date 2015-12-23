class AddFromStoreToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :from_store_id, :integer

    Order.all.each do |order|
      order.update(:from_store_id => order.receipts.first.try(:to_store_id))
    end
  end
end
