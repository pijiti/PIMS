class UnitDose < ActiveRecord::Base

	has_many :brands


	before_create :sentence_case



	Unit_Types = %w{Oral Topical Inhalational Parental Suppository}


	def unit_type
		"#{unit_dose_name}"+"("+"#{unit_dose_type}"+")"
	end

	def sentence_case
		self.unit_dose_name = unit_dose_name.capitalize
	end

 end
