class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
       if user.has_role? "Admin"
         can :manage, :all
       elsif user.has_role? "Pharmacist"
         can :manage , Patient
       elsif user.has_role? "Pharmacist Technician"
         can :manage , Patient
       elsif user.has_role? "Store Keeper"
         can :manage , Supply
       elsif user.has_role? "Store Manager"
         can :manage , Supply
       elsif user.has_role? "Auditor"
         #temporary
         can :manage , Surcharge
       end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
