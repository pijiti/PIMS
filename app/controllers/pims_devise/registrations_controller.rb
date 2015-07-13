class PimsDevise::RegistrationsController < Devise::RegistrationsController

  #added because of the below error during create user call
  #Filter chain halted as :require_no_authentication rendered or redirected
  skip_before_filter :require_no_authentication, :only => [:create]

  def new
    @user = User.new
    @titles = Title.order(:title_name)
    @staffcategories = StaffCategory.order(:staff_category_name)
  end

  def create
    @user = User.new(user_sign_up)
    logger.debug "#{@user.encrypted_password}"
    #admin role gets added here --- how is it working after commenting?
    #logger.debug "Role ids-------> #{params[:user][:role_ids].select { |i| i.present? }}"
    #@user.roles << Role.find(18)

    if @user.save
      #for store roles
      params[:user][:stores].try(:each) do |store_id, store|
        store.each do |k, roles|
          #add role specific to a store
          roles.each do |role|
            logger.debug "=======store id =#{store_id}+++++++"
            @user.add_role role, Store.find_by_id(store_id)
          end
        end
      end
    else
      flash[:error] = "Mandatory fields missing"
    end


    redirect_to users_path
  end


  private

  def user_sign_up
    params.require(:user).permit(:title_id, :first_name, :last_name, :username, {:store_ids => []}, :staff_category_id, :admin, :active_status, :validity, :password, :password_confirmation, {:role_ids => []},)
    #  {:stores => [ {:store_roles => [] }]}
  end


end

