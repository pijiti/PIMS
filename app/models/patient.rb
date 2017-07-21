class Patient < ActiveRecord::Base


	belongs_to :title
	has_many :prescriptions

	validates :title_id, presence: true
	validates :firstname, presence: true, length:{in:3..15}
	validates :surname, presence: true,length:{in: 3..15}
	validates :hospital_number, presence: true,uniqueness: true, length:{in: 2..10}
  validates :address , presence: true
  #validates :inpatient_number, presence: true,uniqueness: true, length:{in: 2..10}
	#validates :mobile,presence: true, uniqueness: true, length:{in:10..11},numericality:{only_integer: true}
	#validates :age, presence: true, length:{in:1..3},numericality:{only_integer: true, greater_than_or_equal_to: 0,less_than_or_equal_to: 100}
  #validates :nok_mobile,presence: true, length:{in:10..11},numericality:{only_integer: true}

	before_create :modify_attrs
	before_update :modify_attrs
	#before_validation :name_unique

	enum gender: {None: 0, Male: 1, Female: 2}

	def modify_attrs
		self.gender = gender.to_i
		self.surname = surname.capitalize.strip
		self.firstname = firstname.capitalize.strip
		self.hospital_number = hospital_number.upcase.strip
		self.mobile = mobile.strip
		self.nok_name = nok_name.titleize.strip
		self.nok_mobile = nok_mobile.strip
	end

	def name_unique
		self.hospital_id = patient_hospital_id.upcase.strip
		self.patient_mobile = patient_mobile.strip
	end

	def name
		@name ||= "#{firstname} #{surname}"
	end

	def initial
		"#{surname} #{firstname.try(:first)}"
	end

	def initial_reverse
		" #{firstname.try(:first)} #{surname}"
	end

end
