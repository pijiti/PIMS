class BringingOrderIdToReceipts < ActiveRecord::Migration
  def change

    Receipt.all.each do |r|
      r.update(:order => r.service_request.order) if r.order.blank?  and r.service_request
    end
    Receipt.where(:confirm_receipt => "COMPLETED").each do |r|
      r.order.update(:status => "DELIVERY_COMPLETE") if r.order
    end
  end
end
