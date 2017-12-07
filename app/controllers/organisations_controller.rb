class OrganisationsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
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
    authorize @organisation
    @error = @organisation.errors.full_messages.to_sentence unless @organisation.save!
  end


  def update
    @organisation.attributes = organisation_params
    @error = @organisation.errors.full_messages.to_sentence unless @organisation.save!
  end


  def destroy
    authorize  @organisation
    @error = @organisation.errors.full_messages.to_sentence unless  @organisation.destroy!
  end

  private
    def set_organisation
      @organisation = Organisation.find(params[:id])
    end

    def organisation_params
      params.require(:organisation).permit(:name, :address, :logo, :contact_person,:contact_phone,:contact_email)
    end
end
