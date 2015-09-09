class Prescription < ActiveRecord::Base

	#include PgSearch
  #pg_search_scope :search_by_main_attributes, against: [:prescription_code],using: [:tsearch, :dmetaphone, :trigrams],
    #ignoring: :accents

	before_create :unique_code

	belongs_to :user
	belongs_to :hospital_unit
	belongs_to :patient
  belongs_to :doctor , class_name: "User"
	has_many :prescription_batches

	accepts_nested_attributes_for :prescription_batches , allow_destroy: true


 #PIMS100000
 #PIMS100001
 #PIMS100002
 def unique_code
 	self.code = "#{PimsConfig.find_by_property_name("prescription_prefix").property_value}-#{SecureRandom.uuid[0..6]}"
 end

end
