module ApplicationController::CurrentstoreConcern
	extend ActiveSupport::Concern

 private

 def set_store
	 session[:active_store] = params[:active_store].to_i
	end

end