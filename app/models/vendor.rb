class Vendor < ActiveRecord::Base

	belongs_to :vendor_category
	has_many :supplies, dependent: :restrict_with_exception
	belongs_to :state
	belongs_to :store

	default_scope{order(name: :asc)}

	validates :name, presence: true, uniqueness: true, length: {in:2..20}
	validates :reg_number, presence: false,length: {maximum: 15}
	validates :address, presence: false,length: {maximum: 75}
	validates :contact_name, presence: true,length: {maximum: 35}
	validates :contact_mobile, presence: true,length: {maximum: 25}
	validates :contact_email, presence: true,length: {maximum: 45}

  attr_accessor :pharm_item_id , :store_id


before_save :modify_attr
before_validation :name_unique

	def modify_attr
		self.name = name.titleize.strip
		self.contact_name = contact_name.titleize.strip
		self.contact_email = contact_email.downcase.strip
	end

	def name_unique
		self.name = name.titleize.strip
	end
end
