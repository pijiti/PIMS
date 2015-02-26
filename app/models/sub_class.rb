class SubClass < ActiveRecord::Base
	has_many :pharm_items, through:  :pharm_items_sub_classes
  belongs_to :item_class


  before_save :modify_attrs

   def modify_attrs
		self.name = name.titleize.strip
		self.description = description.capitalize.strip
	end
end
