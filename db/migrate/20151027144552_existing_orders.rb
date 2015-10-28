class ExistingOrders < ActiveRecord::Migration
  def change
    counter = 0
    ServiceRequest.where(:status => "PENDING").each do |s|
       o = Order.create(:number => "#{PimsConfig.find_by_property_name('order_number_prefix').property_value}-#{1000 + counter}")
       o.service_requests << s
       counter += 1
       puts counter
    end
  end
end
