class Organisation < ActiveRecord::Base


	default_scope{order(name: :asc)}
	before_create :modify_attrs
	before_update :modify_attrs
  before_validation :name_unique

  validates :name, presence: true, uniqueness: true, length: {in:2..15}
  validates :contact_person, presence: true
  validates :contact_phone, presence: true
  validates :contact_email, presence:true



	def modify_attrs
		self.name = name.titleize.strip
		self.address = address.titleize.strip
		self.contact_person = contact_person.titleize.strip
		self.contact_email = contact_email.downcase.strip
	end

	def name_unique
				self.name = name.titleize.strip
	end

end
