class StaffCategory < ActiveRecord::Base

	has_many :users

	before_create :modify_attrs
	before_update :modify_attrs
	before_validation :name_unique

	validates :staff_category_name, presence: true, uniqueness: true


	def modify_attrs
		self.staff_category_name = staff_category_name.titleize.strip
		self.description = description.capitalize.strip
	end

	def name_unique
		self.staff_category_name = staff_category_name.titleize.strip
	end
end
