class PharmItem < ActiveRecord::Base

	has_many :item_classes, through: :itemclass_pharmitems
	has_many :itemclass_pharmitems, :dependent => :destroy
	has_many :brands
	has_many :batches
	has_many :request_items

  before_create :modify_attrs
  before_update :modify_attrs

  validates :pharm_item_name, presence: true, uniqueness: true, length: {in:3..25}
  validates :item_class_id, presence: true
  validates :central_restock_level, presence: true, numericality:{only_integer: true,greater_than: 0},length: {maximum:5}
  validates :main_restock_level, presence: true, numericality:{only_integer: true,greater_than: 0},length: {maximum:5}
  validates :dispensary_restock_level, presence: true, numericality:{only_integer: true,greater_than: 0},length: {maximum:5}
  validates :ward_restock_level, presence: true, numericality:{only_integer: true,greater_than: 0},length: {maximum:5}


	accepts_nested_attributes_for :brands, allow_destroy: true,reject_if: :reject_brands

	def modify_attrs
		self.pharm_item_name =  pharm_item_name .try(:titleize).strip
	end

	def critical_levels
		self.central_critical_level = self.main_critical_level = self.dispensary_critical_level = self.ward_critical_level = 0
		self.central_critical_level ||= (central_restock_level * 0.5).ceil
		self.main_critical_level ||= (main_restock_level * 0.5).ceil
		self.dispensary_critical_level ||= (main_restock_level * 0.5).ceil
		self.ward_critical_level ||= (ward_restock_level * 0.5).ceil
	end

	def has_brand?
		self.brands.length > 0
	end

 private

  def reject_brands(attributed)
    attributed['brand_name'].blank?
  end

end

