class OrganisationsController < ApplicationController
  before_action :set_organisation, only: [:show, :edit, :update, :destroy]


  def index
    @organisations = Organisation.all
    new
  end

  def new
    @organisation = Organisation.new
  end


  def edit
  end


  def create
    @organisation = Organisation.new(organisation_params)
      if @organisation.save
        redirect_to organisations_path
      else
         render :new
    end
  end


  def update
      if @organisation.update(organisation_params)
         redirect_to organisations_path
      else
         render :edit
    end
  end


  def destroy
    @organisation.destroy
     redirect_to organisations_path
  end

  private
    def set_organisation
      @organisation = Organisation.find(params[:id])
    end

    def organisation_params
      params.require(:organisation).permit(:organisation_name, :address, :logo, :contact_person,:contact_phone,:contact_email)
    end
end