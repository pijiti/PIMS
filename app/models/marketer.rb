class Marketer < ActiveRecord::Base

	has_many :brands

	default_scope{order(marketer_name: :asc)}

	validates :marketer_name, presence: true, uniqueness: true, length: {in:2..20}
	validates :description, presence: true,length: {maximum: 50}
	validates :foreign, inclusion: { in: [true, false] }

before_create :modify_attr
before_update :modify_attr
before_validation :name_unique

	def modify_attr
		self.marketer_name = marketer_name.capitalize.strip
		self.description = description.capitalize.strip
	end

	def name_unique
		self.marketer_name = marketer_name.capitalize.strip
	end

end
