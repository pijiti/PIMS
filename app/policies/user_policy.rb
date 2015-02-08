class UserPolicy < ApplicationPolicy

	def interact?
		user.is_admin?
	end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
