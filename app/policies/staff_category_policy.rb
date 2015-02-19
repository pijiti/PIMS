class StoreCategoryPolicy < ApplicationPolicy

	def create
		user.has_admin?
	end

	def edit
		user.has_admin?
	end

	def update
		user.has_admin?
	end

	def destroy
		user.has_admin?
	end

  class Scope < Scope
    def resolve
      scope
    end
  end
end