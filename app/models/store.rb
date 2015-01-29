class Store < ActiveRecord::Base
   resourcify

   before_create :time_zone
   before_update :time_zone

   has_many   :substores, class_name: "Store",  foreign_key: "parent_id"
	 belongs_to  :parent, class_name: "Store"
	 belongs_to :store_type
	 has_many :brands, through: :stocks
	 has_many :vendors
	 has_many :supplies
	 belongs_to :store_operation


	def self.find_by_parent_name
		Store.where(" store_type = 'Central' OR store_type = 'Main' ")
	end

	def time_zone
		self.open_time = open_time.to_time
	  self.close_time = close_time.to_time
	end


end
