class Brand < ActiveRecord::Base

	belongs_to :pharm_item
	belongs_to :marketer
	belongs_to :unit_dose
	belongs_to :item_concentration_unit
	has_many :batches

  before_create :modify_attrs
  after_create :initialise_inventory

  def initialise_inventory
    Store.all.each do |s|
      Inventory.create(:brand_id => self.id , :store_id => s.id , :units => 0)
    end
  end


	def detailed_info
   "#{name} " + "(" + " #{pharm_item.try(:name)}" + " | " + " #{try(:concentration)}" + "#{item_concentration_unit.try(:name)}" + " #{unit_dose.try(:name)}" + " | " + " #{marketer.try(:name)} " + " )"
	end

	def modify_attrs
		self.name = name.try(:titleize)
	end


end
