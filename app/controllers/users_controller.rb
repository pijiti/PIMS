class UsersController < ApplicationController
  before_action :authenticate_user! , :except => [:password_reset , :password_edit , :password_change ]
  before_action :set_user, except: [:index, :password_edit, :password_change]


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

    #for store roles
    @user.roles.destroy_all

    #for admin role
    @user.roles << Role.find(params[:user][:role_ids].select { |i| i.present? })

    params[:user][:stores].try(:each) do |store_id, store|
      store.each do |k, roles|
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
    #send sms
    send_sms(@user.username , "Hello #{@user.first_name}, Your password has been reset for your login at PIMS . Login with Username:#{@user.username} , Password: password. Thank you")
    @error = @user.errors.full_messages.to_sentence
  end


  def password_edit
    logger.debug "----------------------------------------------------------"
    #logger.debug"Current User ID:#{current_user.id}"
    @user = current_user
    render :layout => "layout_without_sidebar"
  end


  def password_change
    logger.debug "=======PASSWD CHANGE========"
    me = params[:id].to_i
    @user = User.find(me)
    logger.debug { "User ID: #{@user.id }" }
    password_status = @user.password_change_check?(params[:user][:current_password], params[:user][:password])
    puts "======#{password_status}"
    if @user.update_with_password(user_password)&& (password_status == false)
      sign_in @user, :bypass => true
      if @user.has_role? "Admin"
        redirect_to dashboard_path
      else
        redirect_to store_selections_index_path
      end
    else
      flash[:notice] = "New password must not be the same as your current password" if  password_status
      render :password_edit, :layout => "layout_without_sidebar"
    end
  end

  def destroy
    #authorize @user
    #if admin
    if can? :manage, :all
      @error = @user.errors.full_messages.to_sentence unless @user.destroy!
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.required(:user).permit(:title_id, :first_name, :last_name, :username, {:store_ids => []}, :staff_category_id, {:role_ids => []}, :active_status, :validity , :email  )
  end

  def user_password
    params.required(:user).permit(:current_password, :password, :password_confirmation)
  end

end
