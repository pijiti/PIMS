class PimsDevise::SessionsController < Devise::SessionsController


  layout "login"

  def new
    @user = User.new
  end

  def create
    super
  end

  def destroy
    #super
    sign_out(User)
    @user = User.new
    redirect_to new_user_session_path
  end


  private

  def sign_in_params
    params.require(:user).permit(:username, :password)
  end

  protected


  def after_sign_in_path_for(user)
    logger.debug "========after signin==========="
    logger.debug "#{user.id} ====> #{user.valid_duration}"
    begin
    if me.valid_duration >= Time.now && me.valid_password?(params[:user][:password]) == me.valid_password?('password')
      logger.debug "========First time user========"
      #store current user in session
      session[:user] = me.id
      password_edit_user_path(me.id)
    elsif me.valid_duration < Time.now
      logger.debug "====Validity expired======="
      flash[:notice]= 'Your Validity period has expired! Contact admin'
      destroy_user_session_path

      #redirect_to destroy_user_session_path, flash[:notice]= 'Your Validaty Period Has Expired!,Speak to Admin'
    else
      #user.valid_duration >= Time.now && me.valid_password?(params[:user][:password]) != me.valid_password?('password')
      logger.debug "=========Logging in , based on role========"
      session[:user] = me.id
      if me.has_role? "Admin"
        dashboard_path
      else
        store_selections_index_path
      end
    end
    rescue
      destroy_user_session_path
    end

  end


  #def after_sign_out_path_for(user)
  #  new_user_session_path
  #end


end




