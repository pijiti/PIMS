class ItemClass < ActiveRecord::Base

	has_many :pharm_items, through:  :itemclass_pharmitems
	has_many :itemclass_pharmitems

	default_scope{order(name: :asc)}
	before_create :modify_attrs
	before_update :modify_attrs
	before_validation :name_unique

	validates :name, presence: true, uniqueness: true,length: { in:2..30}
	validates :description, presence: true

	def modify_attrs
		self.name = name.downcase.strip
		self.description = description.downcase.strip
	end

	def name_unique
		self.name = name.downcase.strip
	end

end
