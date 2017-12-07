class UserProfilesController < ApplicationController
  load_and_authorize_resource
  # before_action :set_user_profile, only: [:show, :edit, :update, :destroy]



  def edit

  end



  def update
      if @user_profile.update(user_profile_params)
       redirect_to @user_profile
      else
         render :edit
    end
  end




  private

    def set_user_profile
      @user_profile = UserProfile.find(params[:id])
    end


    def user_profile_params
      params.require(:user_profile).permit(:gender_id, :DoB, :address, :next_of_kin, :next_of_kin_mobile, :state_id, :local_id)
    end
end
