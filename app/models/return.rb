class Return < ActiveRecord::Base
  belongs_to :prescription
  has_many :return_prescription_batches, :dependent => :destroy
  accepts_nested_attributes_for :return_prescription_batches, allow_destroy: true
  after_create :update_prescription_refunded_amount

  def update_prescription_refunded_amount
    prev_return_refund_amount = 0
    prev_return = Return.where(prescription_id: self.prescription.id).where.not(id: self.id)
    if !prev_return.blank? and !prev_return.last.blank? and !prev_return.last.prescription.blank? and !prev_return.last.prescription.refunded_amount.blank?
      prev_return_refund_amount = prev_return.last.prescription.refunded_amount
    end
    self.prescription.update refunded_amount: ("%.2f" % (self.total.to_f + prev_return_refund_amount.to_f))
    self.save
  end

  def refund_total_update
    total = 0
    self.return_prescription_batches.each do |rpb|
      total += rpb.rate.to_f * rpb.qty.to_f
    end
    self.total = total.floor
    self.prescription.update refunded_amount: self.total
    self.save
  end

end
