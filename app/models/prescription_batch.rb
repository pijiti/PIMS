class PrescriptionBatch < ActiveRecord::Base
  belongs_to :prescription
  belongs_to :pharm_item
  belongs_to :brand
  belongs_to :store

  has_many :collation_batches , :dependent => :destroy
  has_many :inventory_batches , :through => :collation_batches
  accepts_nested_attributes_for :inventory_batches , :allow_destroy => true , reject_if: :all_blank
  accepts_nested_attributes_for :collation_batches , :allow_destroy => true , reject_if: :all_blank

  validates :qty, presence: true , numericality:{greater_than: 0}
  validates_presence_of :rate , :store_id
  validate :rate_blank_check
  validate :check_available_qty
  validate :multiples_of_min_dispensable
  validate :check_store

  before_update :total_calculation

  def check_store
    if !self.store.blank?
      errors.add(:store , "Cannot create prescriptions for main stores") if self.store.parent.blank?
    end
  end

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
    available_units  = i.inventory_batches.where(:expired => nil).sum(:units) if i
    if i.blank?
      errors.add(:brand , "#{brand.try(:name)} is unavailable in the store")
    elsif available_units.to_i < self.qty.to_i
      errors.add("" , "#{available_units} of #{brand.try(:name)} available in the store")
    end
  end

  def multiples_of_min_dispensable
    if qty.to_i % brand.min_dispensable != 0
      errors.add("" , "#{brand.name} must be dispensed as multiples of #{brand.min_dispensable}" )
    end
  end

end
