class ApplicationController < ActionController::Base
   include AuthorizationConcern
   rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery with: :exception

    alias_method :me, :current_user

    #before_action :authenticate_user!

    def set_store
    	session[:active_store] = params[:store_id].to_i
    end

    def current_store
      @current_store ||= Store.find(session[:active_store]) if session[:active_store]
    end
   helper_method :current_store

    def user_not_authorized
    	flash[:notice] = ""
   end



end

