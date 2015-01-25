class PimsDevise::SessionsController < Devise::SessionsController
	layout "login"


 def new
		@user = User.new
	end

 def create
		super
	end

	def destroy
		super
	end




  private

  def sign_in_params
		params.require(:user).permit(:username, :password)
  end

 protected




 def after_sign_in_path_for(user)
 	if me.valid_duration >= Time.now && me.sign_in_count == 1
			      password_edit_user_path(me.id)
	elsif me.valid_duration < Time.now
		       redirect_to destroy_user_session_path, notice: 'Your Validaty Period Has Expired!,Speak to Admin'
	else  me.valid_duration >= Time.now  &&  me.sign_in_count > 1
		       if me.has_role? :admin
		           marketers_path
		      else
		           store_selections_index_path
		     end
		end
	end



  def after_sign_out_path_for(user)
    new_user_session_path
  end




end




