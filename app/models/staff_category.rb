class StaffCategory < ActiveRecord::Base

	has_many :users, dependent: :restrict_with_exception

	default_scope {order(name: :asc) }

	before_create :modify_attrs
	before_update :modify_attrs
	before_validation :name_unique

	validates :name, presence: true, uniqueness: true


	def modify_attrs
		self.name = name.titleize.strip
		self.description = description.capitalize.strip
	end

	def name_unique
		self.name = name.titleize.strip
	end
end
