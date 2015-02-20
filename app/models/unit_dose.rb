class UnitDose < ActiveRecord::Base

	has_many :brands,dependent: :restrict_with_exception

  default_scope {order(name: :asc)}
	before_create :sentence_case

validates :name, presence: true
validates :form_type, presence: true

	Unit_Types = %w{Oral Topical Inhalational Parental Suppository Accessory}


	def unit_type
		"#{name}"+"("+"#{form_type}"+")"
	end

	def sentence_case
		self.name = name.capitalize
	end

 end
