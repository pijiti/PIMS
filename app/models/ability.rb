class Ability
  include CanCan::Ability

  def initialize(user,current_store)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   current_store ||= Store.find(session[:active_store]) if session[:active_store]
       if user.has_role? "Admin"
         can :manage, :all
       end

       if user.has_role? "Pharmacist" , current_store
         can :manage , Patient
         can :manage , Prescription
         can :manage , Inventory
         can :manage , Receipt
       end

       if user.has_role? "Pharmacy Technician" , current_store
         can :manage , Patient
         can :manage , Prescription
         can :manage , Inventory
         can :manage , Receipt
       end

       if user.has_role? "Store Keeper" , current_store
         can :manage , Supply
       end

       if user.has_role? "Store Manager" , current_store
         can :manage , Supply
         #dummy condition for approval
         can :manage , Store
       end

       #current store must be central for accepting orders
       if current_store.try(:store_type).try(:name).try(:upcase).try(:include? , "MAIN STORE")
         can :manage , Vendor
       end

       if user.has_role? "Auditor" , current_store
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
