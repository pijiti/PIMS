class StoreSelectionsController < ApplicationController

	#rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


	before_action :set_store, only: [:select_store]
   layout "selection"


  def index
  	@stores = Store.where("open_time <  ? and close_time >  ? ", Time.now , Time.now)
  end




  def select_store
    authorize current_store
		logger.debug{"Epitome #{ current_store.id}" }
		c_time =  @current_store.close_time
		o_time = @current_store.open_time
		d_time = o_time - c_time

		logger.debug{"#{ o_time}"}
		logger.debug{"#{c_time }"}
		logger.debug{"#{d_time }"}
		logger.debug{"#{Time.now}"}

    redirect_to dashboard_path
  end


  private

  def user_not_authorized
  	flash[:alert] = "You are not authorized to access the selected store.Speak to the PIMS admin."
    redirect_to(:back)
  end



end
