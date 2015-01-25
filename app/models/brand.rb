class Brand < ActiveRecord::Base

	belongs_to :pharm_item
	belongs_to :marketer
	belongs_to :unit_dose
	belongs_to :item_concentration_unit
	has_many :batches

  before_create :modify_attrs




	def detailed_info
   "#{brand_name} " + "(" + " #{pharm_item.try(:pharm_item_name)}" + " | " + " #{try(:concentration)}" + "#{item_concentration_unit.try(:conc_unit_name)}" + " #{unit_dose.try(:unit_dose_name)}" + " | " + " #{marketer.try(:marketer_name)} " + " )"
	end

	def modify_attrs
		self.brand_name = brand_name.try(:titleize)
	end


end
