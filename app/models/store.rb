class Store < ActiveRecord::Base
   resourcify

   has_many   :substores, class_name: "Store",  foreign_key: "parent_id"
	 belongs_to  :parent, class_name: "Store"
	 belongs_to :store_type
	 has_many :brands
	 has_many :vendors
	 has_many :supplies
	 belongs_to :store_operation


	def self.find_by_parent_name
		Store.where(" store_type = 'Central' OR store_type = 'Main' ")
	end

  default_scope{order(name: :asc)}

	validates :name, presence: true, uniqueness: true, length: {in:2..20}
	validates :store_type, presence: true
	validates :store_operation, presence: true


	before_create :modify_attr
	before_update :modify_attr
	before_validation :name_unique

	def modify_attr
		self.name = name.capitalize.strip
		self.description = description.capitalize.strip
	end

	def name_unique
		self.name = name.capitalize.strip
	end



end
