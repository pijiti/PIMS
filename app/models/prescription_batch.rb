class PrescriptionBatch < ActiveRecord::Base
  belongs_to :prescription
  belongs_to :pharm_item
  belongs_to :brand
  belongs_to :store
  validates_presence_of :qty, :rate , :store_id
  validate :rate_blank_check
  validate :check_available_qty
  before_update :total_calculation

  def rate_blank_check
    if self.rate.blank?
      errors.add(:rate, "can't be blank")
    elsif self.rate == "NA"
      errors.add(:brand, "is not available in the store")
    end
  end

  def total_calculation
    logger.info "PRESCRIPTION batches total========="
    self.prescription.total_calculation
  end

  def check_available_qty
    puts "Store id => #{self.store_id}"
    puts "brand id => #{self.brand_id}"
    i = Inventory.where(:brand_id => self.brand_id , :store_id => self.store_id).first
    available_units  = i.inventory_batches.sum(:units) if i
    if i.blank?
      errors.add(:brand , "#{brand.try(:name)} is unavailable in the store")
    elsif available_units.to_i < self.qty.to_i
      errors.add("" , "#{available_units} of #{brand.try(:name)} available in the store")
    end
  end

end
