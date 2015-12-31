class ServiceRequest < ActiveRecord::Base
  belongs_to :request_store , :class_name => "Store"
  belongs_to :from_store , :class_name => "Store"
  belongs_to :pharm_item
  belongs_to :brand
  belongs_to :order
  has_many :receipts  , :dependent => :destroy
  validate :zero_qty_validation

  def zero_qty_validation
    if qty.to_i <= 0
      errors.add(:qty , "invalid")
    end
  end

end
