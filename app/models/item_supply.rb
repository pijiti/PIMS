class ItemSupply < ActiveRecord::Base

	belongs_to :supply
	has_many :batches
	belongs_to :brand
	belongs_to :pharm_item

   accepts_nested_attributes_for :batches
end
