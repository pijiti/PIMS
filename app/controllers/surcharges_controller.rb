class SurchargesController < ApplicationController
  before_action :set_surcharge, only: [:edit, :update, :destroy]
  before_action :set_all_surcharges, only: [:index]
  #respond_to :html


  def index
    new
  end

  def new
    @surcharge = Surcharge.new
    @surcharge.surcharge_items.build
  end

  def edit
    @surcharge.surcharge_items.build
  end


  def create
    @surcharge = Surcharge.new(surcharge_params)
    begin
      #authorize @surcharge
      @surcharge.save!
    rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    rescue StandardError::Pundit::NotAuthorizedError => e
      @error = e.message
    end
  end

  def update
    begin
      @surcharge.attributes = surcharge_params
      #authorize @surcharge
      @surcharge.save!
    rescue ActiveRecord::RecordInvalid => invalid
      @error = invalid.record.errors.full_messages.first
    rescue StandardError::Pundit::NotAuthorizedError => e
      @error = e.message
    end
  end

  def destroy
    begin
      #authorize @surcharge
      @surcharge.destroy!
    rescue ActiveRecord::DeleteRestrictionError => e
      @error = e.message
    end
  end


  private

  def set_surcharge
    @surcharge = Surcharge.find(params[:id])
  end

  def set_all_surcharges
    @surcharges = Surcharge.all
  end

  def surcharge_params
    params.require(:surcharge).permit(:name, :charge_type, :active, surcharge_items_attributes: [:id, :name, :description, :value , :_destroy])
  end

end
