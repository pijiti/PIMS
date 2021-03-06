require 'rest-client'
require 'uri'

class ApplicationController < ActionController::Base
  include AuthorizationConcern
  #rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery with: :exception


  alias_method :me, :current_user
  helper_method :current_store
  #before_action :authenticate_user!

  def current_ability
    @current_ability ||= Ability.new(current_user, current_store)
  end

  def set_store
    session[:active_store] = params[:store_id].to_i
  end

  def current_store
    @current_store ||= Store.find(session[:active_store]) if session[:active_store]
    logger.debug "=======>Current store=====>#{@current_store.name}" if @current_store
    @current_store
  end

  helper_method :current_store

  def user_not_authorized
    flash[:notice] = ""
  end

  def current_user
    @current_user ||= User.find(session[:user]) if session[:user]
  end

  def send_sms(to,message)
    begin
    if Rails.env == "production"
      RestClient.delay.get(URI.encode "http://www.estoresms.com/smsapi.php?username=#{$sms_user}&password=#{$sms_pwd}&sender=#{$sms_sender}&recipient=#{to}&message=#{message}")
    end
    rescue => e
      logger.error "SMS delivery error => #{e.message}"
    end
  end


end

