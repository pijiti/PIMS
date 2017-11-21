module ReturnsHelper
	def refund_total_calculation(refund)
		total = 0
		refund.return_prescription_batches.each do |rpb|
			  total += rpb.rate.to_f * rpb.qty.to_f
		end
		total.floor
	end
end
