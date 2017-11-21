class Store < ActiveRecord::Base
	resourcify

	has_many :substores, class_name: "Store", foreign_key: "parent_id"
	belongs_to :parent, class_name: "Store"
	belongs_to :store_type
	has_many :batches
	#has_many :vendors
	has_many :supplies, :dependent => :destroy
	has_many :inventories, :dependent => :destroy
	has_many :returns, :dependent => :destroy
	belongs_to :store_operation

	validates_presence_of :close_time, :open_time, :store_roles
	validates_uniqueness_of :name


	default_scope {order(name: :asc)}

	validates :name, presence: true, uniqueness: true, length: {in: 2..20}
	validates :store_type, presence: true
	validates :store_operation, presence: true


	before_save :modify_attr
	before_validation :name_unique

	#permissible roles within this array
	serialize :store_roles

	attr_accessor :active_store

	def modify_attr
		self.name = name.titleize.strip
	end

	def name_unique
		self.name = name.titleize.strip
	end


	def self.to_csv(options = {})
		CSV.generate(options) do |csv|
			csv << column_names
			all.each do |user|
				csv << user.attributes.values_at(*column_names)
			end
		end
	end

	# need to refactor - getting role count and user names for the current_store
	def self.get_user_roles(current_store)

		user_list = User.with_any_role(
		{:name => "Admin", :resource => current_store},
		{:name => "Auditor", :resource => current_store},
		{:name => "Pharmacist", :resource => current_store},
		{:name => "Pharmacy Technician", :resource => current_store},
		{:name => "Store Keeper", :resource => current_store},
		{:name => "Store Manager", :resource => current_store})
		roles = Role.all.pluck(:name).uniq.compact
		role_count_hash, role_store_hash = {}, {}
		roles.each do |role|
			role_count_hash[role] = 0
			role_store_hash[role] = []
		end
		user_list.each do |user|
			if user.has_role? "Admin"
				role_count_hash["Admin"] += 1
				role_store_hash["Admin"] << user.first_name + " " +user.last_name
			end

			if user.has_role? "Auditor", current_store
				role_count_hash["Auditor"] += 1
				role_store_hash["Auditor"] << user.first_name + " " +user.last_name
			end

			if user.has_role? "Pharmacist", current_store
				role_count_hash["Pharmacist"] += 1
				role_store_hash["Pharmacist"] << user.first_name + " " +user.last_name
			end

			if user.has_role? "Pharmacy Technician", current_store
				role_count_hash["Pharmacy Technician"] += 1
				role_store_hash["Pharmacy Technician"] << user.first_name + " " +user.last_name
			end

			if user.has_role? "Store Keeper", current_store
				role_count_hash["Store Keeper"] += 1
				role_store_hash["Store Keeper"] << user.first_name + " " +user.last_name
			end

			if user.has_role? "Store Manager", current_store
				role_count_hash["Store Manager"] += 1
				role_store_hash["Store Manager"] << user.first_name + " " +user.last_name
			end
		end
		#Store.all.each do |store|
		#  store_roles = store.roles.pluck(:name)
		#  store_roles.each do |store_role|
		#    role_count_hash[store_role] += 1
		#    role_store_hash[store_role] << store.name
		#  end
		#end
		[role_count_hash, role_store_hash]
	end

end
