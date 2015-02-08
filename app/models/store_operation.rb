class StoreOperation < ActiveRecord::Base
	has_many :stores

	before_create :modify_attrs

	def modify_attrs
		self.store_operation_name = store_operation_name.upcase.strip
	end
end
