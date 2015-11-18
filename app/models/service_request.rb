class ServiceRequest < ActiveRecord::Base
  belongs_to :request_store , :class_name => "Store"
  belongs_to :from_store , :class_name => "Store"
  belongs_to :pharm_item
  belongs_to :brand
  belongs_to :order
  has_many :receipts
end
