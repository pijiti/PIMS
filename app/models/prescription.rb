class Prescription < ActiveRecord::Base

	#include PgSearch
  #pg_search_scope :search_by_main_attributes, against: [:prescription_code],using: [:tsearch, :dmetaphone, :trigrams],
    #ignoring: :accents

	before_create :unique_code

	belongs_to :user
	belongs_to :hospital_unit
	belongs_to :patient
	has_many :batches

	accepts_nested_attributes_for :batches , allow_destroy: true


 def unique_code
 	count = 0
 	self.code = "PLN-%.6d" % count=+1
 end

end
