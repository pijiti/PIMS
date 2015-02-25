class Marketer < ActiveRecord::Base

	has_many :brands

	default_scope{order(name: :asc)}

	validates :name, presence: true, uniqueness: true, length: {in:2..20}
	validates :description, presence: false, uniqueness: true, length: {maximum:50}
	validates :foreign, inclusion: { in: [true, false] }

before_save :modify_attr
before_validation :name_unique

	def modify_attr
	self.name = name.capitalize.strip
	self.description = description.capitalize.strip
	end

	def name_unique
		self.name = name.capitalize.strip
	end

end
