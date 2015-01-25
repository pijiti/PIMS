class ItemclassPharmitem < ActiveRecord::Base

	belongs_to :item_class
	belongs_to :pharm_item
end
