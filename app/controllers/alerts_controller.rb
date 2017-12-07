class AlertsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  before_action :set_alert, only: [:show, :edit, :update, :destroy]

  def mark_all_as_read
    current_user.unread_alerts.update_all(:status => "READ")
    render "alerts"
  end

  def clear
    current_user.read_alerts.update_all(:status => "CLEARED")
    render "alerts"
  end

  def get_notifications
    Alert.find(params[:alert_id]).update(:status => "READ") if params[:alert_id]
    @user_alerts =  current_user.get_alerts
  end

  def create_custom_alert
    store     = Store.find(params[:store_name])
    message   = params[:notif_message] || "Custom Alert"
    roles     = (params[:role_names]) ? params[:role_names] : []
    role_hash = Hash.new
    roles.each do |role|
      User.with_any_role({:name => role, :resource => store}).each do |u|
        next if role_hash[u.id]
        role_hash[u.id] = u
        #create alerts
        Alert.create(:store => store, :user => u, :status => "UNREAD", :order => nil, :alert_type => "CUSTOM", :message => message)
      end
    end
    flash[:notice] = (roles.blank?) ? "No Users found" : "Notification Sent"
    redirect_to dashboard_path
  end

  # GET /alerts
  # GET /alerts.json
  def index
    @alerts = Alert.all
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
  end

  # GET /alerts/new
  def new
    @alert = Alert.new
  end

  # GET /alerts/1/edit
  def edit
  end

  # POST /alerts
  # POST /alerts.json
  def create
    @alert = Alert.new(alert_params)

    respond_to do |format|
      if @alert.save
        format.html { redirect_to @alert, notice: 'Alert was successfully created.' }
        format.json { render :show, status: :created, location: @alert }
      else
        format.html { render :new }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alerts/1
  # PATCH/PUT /alerts/1.json
  def update
    respond_to do |format|
      if @alert.update(alert_params)
        format.html { redirect_to @alert, notice: 'Alert was successfully updated.' }
        format.json { render :show, status: :ok, location: @alert }
      else
        format.html { render :edit }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert.destroy
    respond_to do |format|
      format.html { redirect_to alerts_url, notice: 'Alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert
      @alert = Alert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alert_params
      params.require(:alert).permit(:message, :store_id, :status, :user_id)
    end
end
