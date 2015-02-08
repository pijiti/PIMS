class StorePolicy < ApplicationPolicy
	attr_reader :store

  def initialize(user, record)
     super(user, record)
     @store = record
  end


	def select_store?
		user.is_Technical_of?@store or user.is_principal_of?@store
  end

end