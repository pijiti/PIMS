class Title < ActiveRecord::Base

	has_many :users
	has_many :patients

	default_scope {order(title_name: :asc) }
end
