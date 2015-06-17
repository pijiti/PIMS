class PimsDevise::RegistrationsController < Devise::RegistrationsController


 def new
		@user = User.new
		@titles = Title.order(:title_name)
		@staffcategories = StaffCategory.order(:staff_category_name)
	end

 def create
		@user = User.new(user_sign_up)
		logger.debug "#{@user.encrypted_password}"
		@user.roles << Role.find(params[:user][:role_ids].select{|i| i.present? })
		@user.save!
		redirect_to users_path
	end


	private

  def user_sign_up
    params.require(:user).permit(:title_id, :first_name, :last_name, :username,{:store_ids=>[]},:staff_category_id, :admin,:active_status, :validity,:password, :password_confirmation , {:role_ids => [] })
  end


end

