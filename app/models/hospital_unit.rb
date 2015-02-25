class HospitalUnit < ActiveRecord::Base

	has_many :prescriptions, dependent: :restrict_with_exception

	default_scope{order(name: :asc)}
	validates :name, presence: true, uniqueness: true, length: { in: 2..15 }
	validates :description,presence: false,length: { maximum: 50 }

	before_save :modify_attrs

	before_validation :name_unique


	def modify_attrs
		self.name = name.upcase.strip
		self.description = description.capitalize.strip
	end

	def name_unique
		self.name = name.upcase.strip
	end

end
