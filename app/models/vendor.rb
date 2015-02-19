class Vendor < ActiveRecord::Base

	belongs_to :vendor_category
	has_many :supplies
	belongs_to :state
	belongs_to :store

	default_scope{order(name: :asc)}

	validates :name, presence: true, uniqueness: true, length: {in:2..20}
	validates :reg_number, presence: true,length: {maximum: 15}
	validates :vendor_category, presence: true
	validates :address, presence: true,length: {maximum: 75}
	validates :store, presence: true
	validates :contact_name, presence: true,length: {maximum: 35}
	validates :contact_email, presence: true,length: {maximum: 45}
	validates :contact_mobile, presence: true,length: {maximum: 25}


before_create :modify_attr
before_update :modify_attr
before_validation :name_unique

	def modify_attr
		self.name = name.upcase.strip
		self.contact_name = contact_name.titleize.strip
		self.contact_email = contact_email.downcase.strip
	end

	def name_unique
		self.name = name.upcase.strip
	end
end
