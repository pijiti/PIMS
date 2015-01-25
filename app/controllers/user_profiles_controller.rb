class UserProfilesController < ApplicationController
  before_action :set_user_profile, only: [:show, :edit, :update, :destroy]


  def index
    @user_profiles = UserProfile.all
    new
  end


  def new
    @user_profile = UserProfile.new
  end


  def edit
  end


  def create
    @user_profile = UserProfile.new(user_profile_params)

    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to edit_user_profile_path(@user_profile), notice: 'User profile was successfully created.' }
        format.json { render :show, status: :created, location: @user_profile }
      else
        format.html { render :new }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @user_profile.update(user_profile_params)
        format.html { redirect_to @user_profile, notice: 'User profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_profile }
      else
        format.html { render :edit }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user_profile.destroy
    respond_to do |format|
      format.html { redirect_to user_profiles_url, notice: 'User profile was successfully destroyed.' }
      format.json { head :no_content }
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
