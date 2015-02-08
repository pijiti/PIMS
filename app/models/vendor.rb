class Vendor < ActiveRecord::Base

	belongs_to :vendor_category
	has_many :supplies
	belongs_to :state
	belongs_to :store

	validates :name, presence: true
	validates :reg_number, presence: true
	def modify_attrs

	end
end
