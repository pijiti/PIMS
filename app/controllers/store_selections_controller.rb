class StoreSelectionsController < ApplicationController

	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  #before_action :authenticate_user!

	before_action :set_store, only: [:select_store]
   layout "selection"


  def index
  	@stores = Store.where("open_time  <  ? and close_time at time zone 'UTC' > ? ", Time.now , Time.now.in_time_zone('UTC') )
  end


  def select_store
   @store = Store.find(session[:active_store])
    authorize @store
		logger.debug{"Epitome #{ session[:active_store]}" }

    redirect_to dashboard_index_path
  end


  private

  def user_not_authorized
    redirect_to store_selections_index_path
  end



end
