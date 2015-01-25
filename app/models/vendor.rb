class Vendor < ActiveRecord::Base

	belongs_to :vendor_category
	has_many :supplies
	belongs_to :state
	belongs_to :store
end
