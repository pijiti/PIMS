class UserProfile < ActiveRecord::Base
	belongs_to :gender
	belongs_to :state
end
