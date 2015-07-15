class PharmItem < ActiveRecord::Base

	has_many :sub_classes, through: :pharm_item_sub_classes
	has_many :pharm_item_sub_classes, :dependent => :destroy
	has_many :brands
	has_many :batches
	has_many :request_items

	default_scope  { order(:name => :asc) }

  before_create :modify_attrs
  before_update :modify_attrs
  before_validation :name_unique

  validates :name, presence: true, uniqueness: true, length: {in:3..25}
  #validates :central_restock_level, presence: true, numericality:{greater_than: 0},length: {maximum:5}
  validates :main_restock_level, presence: true, numericality:{greater_than: 0},length: {maximum:5}
  validates :dispensary_restock_level, presence: true, numericality:{greater_than: 0},length: {maximum:5}
  #validates :ward_restock_level, presence: true, numericality:{greater_than: 0},length: {maximum:5}


	accepts_nested_attributes_for :brands, allow_destroy: true,reject_if: :reject_brands

	def modify_attrs
		self.name =  name .try(:titleize).strip
	end

	def name_unique
		self.name =  name .try(:titleize).strip
	end

	def critical_levels
		#self.central_critical_level = (central_restock_level * 0.5).ceil
		#	self.central_critical_level ||= 0
		self.main_critical_level = (main_restock_level * 0.5).ceil
			self.main_critical_level ||= 0
		self.dispensary_critical_level = (dispensary_restock_level * 0.5).ceil
		self.dispensary_critical_level ||= 0
		#self.ward_critical_level = (ward_restock_level * 0.5).ceil
		#self.ward_critical_level ||= 0
	end

	def has_brand?
		self.brands.length > 0
	end

 private

  def reject_brands(attributed)
      attributed[:name].blank? ||
      attributed[:pack_size].blank? ||
      attributed[:min_dispensable].blank? ||
      attributed[:marketer_id].blank? ||
      attributed[:unit_dose_id].blank?
  end

end

