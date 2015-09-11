class Batch < ActiveRecord::Base

  belongs_to :supply
  belongs_to :brand
  belongs_to :pharm_item
  belongs_to :prescription
  belongs_to :request_item
  has_many :inventory_batches , :dependent => :destroy
  has_many :inventories , :through => :inventory_batches

  before_create :set_pharm_item
  before_update :set_pharm_item

  validates_presence_of :rate, :qty , :mfd_date , :expiry_date , :batch_number , :brand
  validates_uniqueness_of :batch_number
  validate :mfd_date_check
  attr_accessor :selector , :allot , :inventory_batch_id , :store_id , :transfer_to_store

  def get_vendor
    self.supply.vendor
  end

  def mfd_date_check
    if self.mfd_date and self.mfd_date > Time.now
      errors.add(:mfd_date, "entered - #{self.mfd_date.strftime("%d/%m/%Y")} is in future")
    end
  end


  def set_pharm_item
    self.giver_store = 0
    self.prescription_id = 0
    self.pharm_item = self.try(:brand).try(:pharm_item)
  end

  def retail_price
    rate = self.rate.to_f
    total_unit =(self.brand.try(:pack_bundle).to_f * self.brand.try(:pack_size).to_f).to_i
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
