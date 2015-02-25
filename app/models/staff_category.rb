class StaffCategory < ActiveRecord::Base

	has_many :users, dependent: :restrict_with_exception

	default_scope {order(name: :asc) }

	before_save :modify_attrs
	before_validation :name_unique

	validates :name, presence: true, uniqueness: true,length:{in:2..20}
	validates :description, presence: false,length:{maximum: 50}


	def modify_attrs
		self.name = name.titleize.strip
		self.description = description.capitalize.strip
	end

	def name_unique
		self.name = name.titleize.strip
	end
end
