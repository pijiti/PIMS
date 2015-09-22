class PrescriptionBatch < ActiveRecord::Base
  belongs_to :prescription
  belongs_to :pharm_item
  belongs_to :brand
  validates_presence_of :qty, :rate
  validate :rate_blank_check

  def rate_blank_check
    if self.rate.blank?
      errors.add(:rate, "can't be blank")
    elsif self.rate == "NA"
      errors.add(:brand, "is not available in the store")
    end
  end

end
