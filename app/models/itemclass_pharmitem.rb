class ItemclassPharmitem < ActiveRecord::Base

	belongs_to :item_class
	belongs_to :pharm_item

  validates_presence_of  :item_class_id, :scope => :pharm_item_id
end
