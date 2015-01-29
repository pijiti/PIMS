class UsersController < ApplicationController
	before_action :set_user, except: [:index,:password_edit,:password_change]


  def index
  	@users = User.paginate(:page => params[:page])
  	@stores = Store.all
  end


  def edit
    @titles = Title.order(:title_name)
		@staffcategories = StaffCategory.all.order(:staff_category_name)
		@stores = Store.all.order(:store_name)
  end


  def show
  end

  def update
    @user.update! user_params
    @user.roles.destroy_all
    @user.roles << Role.find(params[:user][:role_ids].select{|i| i.present? })
  end


  def password_reset
  		begin
  			@user.password_reset
  			 redirect_to users_path
  		rescue=> e
  			 flash[:alert] = e.message
  			 render :new
  	end

  end

  def password_edit
     @user = User.find(me.id)
  end


  def password_change
  	@user = User.find(params[:id])
    pass_value = @user.valid_password?(params[:user][:current_password])
  	passed_value = params[:user][:current_password]
  	logger.debug "current password: #{passed_value}"
  		logger.debug "password status: #{pass_value}"
   password_status = @user.password_change_check?(params[:user][:current_password],params[:user][:password])
   logger.debug " #{password_status}"

   	 if @user.update_with_password(user_password)&& (password_status == false)
      sign_in @user, :bypass => true
       if @user.has_role? :admin
          	redirect_to dashboard_path
           else
           	 redirect_to store_selections_index_path
          end
      else
      	  render :password_edit
   end
  end

  def destroy
  	@user.destroy
  end

  private

  def set_user
  		@user = User.find(params[:id])
  end

  def user_params
    params.required(:user).permit(:title_id, :first_name, :last_name, :username,{:store_ids=>[]},:staff_category_id, {:role_ids => []},:active_status, :validity)
  end

  def user_password
  	params.required(:user).permit(:current_password, :password, :password_confirmation)
  end

end
