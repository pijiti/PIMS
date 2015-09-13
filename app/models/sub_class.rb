class SubClass < ActiveRecord::Base
	has_many :pharm_items, through:  :pharm_item_sub_classes
	has_many :pharm_item_sub_classes
  belongs_to :item_class


  before_save :modify_attrs

  default_scope {includes(:item_class).order('item_classes.name ASC')}

  def sub_main
  	"#{item_class.try(:name)}" + "(" + "#{try(:name)}"+ ")"
  end

   def modify_attrs
		self.name = name.titleize.strip
		self.description = description.capitalize.strip
	end
end
