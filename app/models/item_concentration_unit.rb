class ItemConcentrationUnit < ActiveRecord::Base

	has_many :brands

	before_create :modify_attrs
	before_update :modify_attrs
	before_validation :name_unique

	validates :conc_unit_name, presence: true, uniqueness: true,length: { in:2..10}
	validates :description, presence: true

	def modify_attrs
		self.conc_unit_name = conc_unit_name.downcase.strip
		self.description = description.downcase.strip
	end

	def name_unique
		self.conc_unit_name = conc_unit_name.downcase.strip
	end

end
