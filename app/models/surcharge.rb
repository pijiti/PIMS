class Surcharge < ActiveRecord::Base

	has_many :surcharge_items

	accepts_nested_attributes_for :surcharge_items

	SURCHARGE_TYPES = %w(Fixed Percentage)

	before_save :active_surcharge

	validate :charge_type, inclusion: SURCHARGE_TYPES

  def active_surcharge
  		self.update_all(:active => true)
  end

end
