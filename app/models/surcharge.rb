class Surcharge < ActiveRecord::Base

	has_many :surcharge_items

	accepts_nested_attributes_for :surcharge_items

	SURCHARGE_TYPES = %w(Fixed Percentage)

	validate :surcharge_type, inclusion: SURCHARGE_TYPES


end
