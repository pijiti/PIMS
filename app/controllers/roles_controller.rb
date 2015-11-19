class RolesController < ApplicationController
  before_action :authenticate_user!

	before_action :set_role, only:[:edit,:update,:destroy]
	before_action :set_all_roles, only:[:index]


  def index
  end

  def create
  	@role = Role.new(role_params)
  	if @role.save
  		redirect_to roles_path
  	else
  		render new
  	end
  end

  def edit
  end

  def update
  	if @role.update_attributes(role_params)
  		redirect_to roles_path
  	else
  		render edit
  	end
  end

  def destroy
  end

  def new
  	@role = Role.new
  end

  private

  def set_role
  	@role = Role.find(params[:id])
  end

  def set_all_roles
  	@roles = Role.all
  end

  def role_params
  	params.require(:role).permit(:name)
  end


end
