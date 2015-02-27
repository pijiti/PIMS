class ItemClass < ActiveRecord::Base


	has_many :sub_classes ,dependent: :destroy

  accepts_nested_attributes_for :sub_classes, allow_destroy: true,reject_if: :reject_sub_classes

	default_scope{order(name: :asc)}
	before_save :modify_attrs
	before_validation :name_unique

	validates :name, presence: true, uniqueness: true,length: { in:2..30}
	validates :description, presence: false

	def modify_attrs
		self.name = name.titleize.strip
		self.description = description.capitalize.strip
	end

	def name_unique
		self.name = name.titleize.strip
	end

	private
	def reject_sub_classes(attributed)
      attributed[:name].blank?
  end

end
