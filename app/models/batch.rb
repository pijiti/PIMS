class Batch < ActiveRecord::Base

	belongs_to :supply
	belongs_to :brand
	belongs_to :pharm_item
	belongs_to :prescription
	belongs_to :request_item


def retail_price
	rate = self.rate.to_f
  total_unit =( self.brand.try(:pack_bundle).to_f * self.brand.try(:pack_size).to_f).to_i
  unit_price = (rate / total_unit).ceil
  return unit_price
end

def dispensable_qty
	 self.qty.to_i * brand.try(:pack_size).to_i * brand.try(:pack_bundle).to_i
end

 def line_total

 end


 def batch_validity?
   expiry_date > created_at + 180.days
 end

 def expired_item?
 	expiry_date < Time.now
 end




end
