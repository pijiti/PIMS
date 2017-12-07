class PimsConfigsController < ApplicationController
  load_and_authorize_resource
  # before_action :set_pims_config, only: [:show, :edit, :update, :destroy]

  # GET /pims_configs
  # GET /pims_configs.json
  def index
    @pims_configs = PimsConfig.all
  end

  # GET /pims_configs/1
  # GET /pims_configs/1.json
  def show
  end

  # GET /pims_configs/new
  def new
    @pims_config = PimsConfig.new
  end

  # GET /pims_configs/1/edit
  def edit
  end

  # POST /pims_configs
  # POST /pims_configs.json
  def create
    @pims_config = PimsConfig.new(pims_config_params)

    respond_to do |format|
      if @pims_config.save
        format.html { redirect_to pims_configs_path , notice: 'Pims config was successfully created.' }
        format.json { render :show, status: :created, location: @pims_config }
      else
        format.html { render :new }
        format.json { render json: @pims_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pims_configs/1
  # PATCH/PUT /pims_configs/1.json
  def update
    respond_to do |format|
      if @pims_config.update(pims_config_params)
        format.html { redirect_to pims_configs_path, notice: 'Pims config was successfully updated.' }
        format.json { render :show, status: :ok, location: @pims_config }
      else
        format.html { render :edit }
        format.json { render json: @pims_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pims_configs/1
  # DELETE /pims_configs/1.json
  def destroy
    @pims_config.destroy
    respond_to do |format|
      format.html { redirect_to pims_configs_url, notice: 'Pims config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pims_config
      @pims_config = PimsConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pims_config_params
      params.require(:pims_config).permit(:property_name, :property_value, :description)
    end
end
