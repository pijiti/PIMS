class ItemClass < ActiveRecord::Base

	has_many :pharm_items, through:  :itemclass_pharmitems
	has_many :itemclass_pharmitems
end
