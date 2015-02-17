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
    @organisation = Organisation.create!(organisation_params)
    @error = @organisation.error.full_messages
  end


  def update
    @organisation.update!(organisation_params)
    @error = @organisation.error.full_messages
  end


  def destroy
    @organisation.destroy!
    @error = @organisation.error.full_messages
  end

  private
    def set_organisation
      @organisation = Organisation.find(params[:id])
    end

    def organisation_params
      params.require(:organisation).permit(:name, :address, :logo, :contact_person,:contact_phone,:contact_email)
    end
end
