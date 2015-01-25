class DashboardController < ApplicationController

	def index
    @store = Store.find(session[:active_store] )
	end
end
