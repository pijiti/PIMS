class PimsDevise::RegistrationsController < Devise::RegistrationsController


 def new
		@user = User.new
		@titles = Title.order(:title_name)
		@staffcategories = StaffCategory.order(:staff_category_name)
	end

 def create
		@user = User.new(user_sign_up)
		@user.roles << Role.find(params[:user][:role_ids].select{|i| i.present? })
	end


	private

  def user_sign_up
    params.require(:user).permit(:title_id, :first_name, :last_name, :username,{:store_ids=>[]},:staff_category_id, {:role_ids => []}, :admin,:active_status, :validity,:password, :password_confirmation)
  end


end

