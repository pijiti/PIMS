class State < ActiveRecord::Base

	belongs_to :country
	has_many :locals
	has_many :vendors
	has_many :user_profiles
end
