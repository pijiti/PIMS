class SubClass < ActiveRecord::Base
	has_many :pharm_items, through:  :pharm_items_sub_classes
  belongs_to :item_class
end
