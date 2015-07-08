class UsersController < ApplicationController
	before_action :set_user, except: [:index,:password_edit,:password_change]


  def index
  	@users = User.all
  	@stores = Store.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv }
      format.xls { send_data @users.to_csv(col_sep: "\t") }
    end
  end


  def edit
    @titles = Title.order(:name)
		@staffcategories = StaffCategory.all.order(:name)
		@stores = Store.all.order(:name)
  end


  def update
    @user.attributes = user_params
    #authorize @user
    @user.save!
    @user.roles.destroy_all

    #for admin role
    @user.roles << Role.find(params[:user][:role_ids].select{|i| i.present? })

    #for store roles
    @user.roles.destroy_all
    params[:user][:stores].each do |store_id , store|
      store.each do |k,roles|
        #add role specific to a store
        roles.each do |role|
          logger.debug "=======store id =#{store_id}+++++++"
          @user.add_role role, Store.find_by_id(store_id)
        end
      end
    end

  end


  def password_reset
  			@user.password_reset!
  			@error = @user.errors.full_messages.to_sentence
  	end



  def password_edit
  	logger.debug"----------------------------------------------------------"
  	#logger.debug"Current User ID:#{current_user.id}"
     @user = current_user
     render :layout => "layout_without_sidebar"
  end


  def password_change
    logger.debug "=======PASSWD CHANGE========"
  	me = params[:id].to_i
  	@user = User.find(me)
  	logger.debug{"User ID: #{@user.id }"}
     password_status = @user.password_change_check?(params[:user][:current_password],params[:user][:password])
   	 if @user.update_with_password(user_password)&& (password_status == false)
     sign_in @user, :bypass => true
       if @user.has_role? :admin
          	redirect_to dashboard_path
           else
           	 redirect_to store_selections_index_path
          end
      else
      	 render :password_edit  , :layout => "layout_without_sidebar"
   end
  end

  def destroy
  	#authorize @user
  	@error = @user.errors.full_messages.to_sentence unless @user.destroy!
  end

  private

  def set_user
  		@user = User.find(params[:id])
  end

  def user_params
    params.required(:user).permit(:title_id, :first_name, :last_name, :username,{:store_ids=>[]},:staff_category_id, :role_ids,:active_status, :validity)
  end

  def user_password
  	params.required(:user).permit(:current_password, :password, :password_confirmation)
  end

end
