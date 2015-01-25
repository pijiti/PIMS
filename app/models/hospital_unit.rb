class HospitalUnit < ActiveRecord::Base

	has_many :prescriptions

	validates :hospital_unit_name, presence: true, uniqueness: true, length: { in: 2..15 }
	validates :hospital_unit_description,presence: true,length: { maximum: 50 }

	before_create :modify_attrs
	before_update :modify_attrs
	before_validation :name_unique


	def modify_attrs
		self.hospital_unit_name = hospital_unit_name.upcase.strip
		self.hospital_unit_description = hospital_unit_description.capitalize.strip
	end

	def name_unique
		self.hospital_unit_name = hospital_unit_name.upcase.strip
	end

end
