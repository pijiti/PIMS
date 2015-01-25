class StoreTypesController < ApplicationController


	before_action :set_store, only: [:create]
  before_action :set_store_type, only: [:show, :edit, :update, :destroy]

  # GET /store_types
  # GET /store_types.json
  def index
    @store_types = StoreType.all
  end

  # GET /store_types/1
  # GET /store_types/1.json
  def show
  end

  # GET /store_types/new
  def new
    @store_type = StoreType.new
  end

  # GET /store_types/1/edit
  def edit
  end

  # POST /store_types
  # POST /store_types.json
  def create
    @store_type = StoreType.new(store_type_params)
    logger.debug{"Epitome #{ session[:store_id]}" }

    respond_to do |format|
      if @store_type.save
        format.html { redirect_to @store_type, notice: 'Store type was successfully created.' }
        format.json { render :show, status: :created, location: @store_type }
      else
        format.html { render :new }
        format.json { render json: @store_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /store_types/1
  # PATCH/PUT /store_types/1.json
  def update
    respond_to do |format|
      if @store_type.update(store_type_params)
        format.html { redirect_to @store_type, notice: 'Store type was successfully updated.' }
        format.json { render :show, status: :ok, location: @store_type }
      else
        format.html { render :edit }
        format.json { render json: @store_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store_types/1
  # DELETE /store_types/1.json
  def destroy
    @store_type.destroy
    respond_to do |format|
      format.html { redirect_to store_types_url, notice: 'Store type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store_type
      @store_type = StoreType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_type_params
      params.require(:store_type).permit(:store_type_name)
    end
end
