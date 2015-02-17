class Title < ActiveRecord::Base

	has_many :users
	has_many :patients

	default_scope {order(name: :asc) }
end
