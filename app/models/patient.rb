class Patient < ActiveRecord::Base


	belongs_to :title
	has_many :prescriptions

	validates :title_id, presence: true
	validates :patient_firstname, presence: true, length:{in:3..15}
	validates :patient_surname, presence: true,length:{in: 3..15}
	validates :patient_hospital_id, presence: true,uniqueness: true, length:{in: 2..10}
	validates :patient_mobile,presence: true, uniqueness: true, length:{is:11},numericality:{only_integer: true}
	validates :patient_age, presence: true, length:{in:1..3},numericality:{only_integer: true, greater_than_or_equal_to: 0,less_than_or_equal_to: 100}
  validates :nok_name, presence: true, length:{in:5..25}
  validates :nok_mobile,presence: true, uniqueness: true, length:{is:11},numericality:{only_integer: true}

	before_create :modify_attrs
	before_update :modify_attrs
	before_validation :name_unique

	enum gender: {None: 0, Male: 1, Female: 2}

	def modify_attrs
		self.gender = gender.to_i
		self.patient_surname = patient_surname.capitalize.strip
		self.patient_firstname = patient_firstname.capitalize.strip
		self.patient_hospital_id = patient_hospital_id.upcase.strip
		self.patient_mobile = patient_mobile.strip
		self.nok_name = nok_name.titleize.strip
		self.nok_mobile = nok_mobile.strip
	end

	def name_unique
		self.patient_hospital_id = patient_hospital_id.upcase.strip
		self.patient_mobile = patient_mobile.strip
	end

end
