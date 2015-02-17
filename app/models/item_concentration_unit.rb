class ItemConcentrationUnit < ActiveRecord::Base

	has_many :brands

	default_scope{order(name: :asc)}
	before_create :modify_attrs
	before_update :modify_attrs
	before_validation :name_unique

	validates :name, presence: true, uniqueness: true,length: { in:2..10}
	validates :description, presence: true

	def modify_attrs
		self.name = name.downcase.strip
		self.description = description.downcase.strip
	end

	def name_unique
		self.name = name.downcase.strip
	end

end
