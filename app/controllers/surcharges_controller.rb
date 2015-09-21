class SurchargesController < ApplicationController
  before_action :set_surcharge, only: [:edit, :update, :destroy]
  before_action :set_all_surcharges, only: [:index]
  #respond_to :html


  def index
    new
  end

  #return active surcharge
  def active
    surcharges = {}
    @surcharge = Surcharge.where(:active => true).first
    if @surcharge



      surcharges["charge_type"] = @surcharge.charge_type
      surcharges["items"] = []
      total = 0
      @surcharge.surcharge_items.each do |i|
        temp = {}
        #if @surcharge.charge_type != "Fixed"
        #  temp["name"] = "#{i.name}(#{i.value}%)"
        #else
        #  temp["name"] = i.name
        #end
        temp["name"] = i.name
        temp["value"] = i.value
        total += i.value.to_f
        surcharges["items"] << temp
      end
      surcharges["total"] = total
      if @surcharge.charge_type != "Fixed"
        surcharges["name"] = "#{@surcharge.name}(#{total}%)"
      else
        surcharges["name"] = @surcharge.name
      end
    end

    puts "=========Surcharges========="
    puts surcharges

    respond_to do |format|
      format.json { render json: surcharges }
    end
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
