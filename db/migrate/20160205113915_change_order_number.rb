class ChangeOrderNumber < ActiveRecord::Migration
  def change
    Order.where(:from_store_id => nil).each do |o|
      o.from_store_id = o.service_requests.last.try(:from_store_id)
      o.save
    end
    Order.where("number LIKE ?", "PIMSO-5%").each do |o|
      o.number = o.number.gsub("-", "-0")
      o.save
    end
  end
end
