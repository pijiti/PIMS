class StoreOperation < ActiveRecord::Base
	has_many :stores

	default_scope{order(name: :asc)}

	validates :name, presence: true, uniqueness: true, length: {in:2..20}
	validates :description, presence: true,length: {maximum: 50}


before_create :modify_attr
before_update :modify_attr
before_validation :name_unique

	def modify_attr
		self.name = name.upcase.strip
		self.description = description.capitalize.strip
	end

	def name_unique
		self.name = name.upcase.strip
	end
end
