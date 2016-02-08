class StoreSelectionsController < ApplicationController
  skip_before_filter :check_session
  before_action :authenticate_user!
	#rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


	before_action :set_store, only: [:select_store]
   layout "selection"


  def index
  	#@stores = Store.where("open_time <  ? and close_time >  ? ", Time.now , Time.now)
    current_time = Time.zone.now
    logger.debug "===========Current time[#{current_time}]============"
    current_year = current_time.year
    current_month = current_time.month
    current_day = current_time.day
    ids = []

    if current_user.has_role? "Admin"
      all_stores = Store.all
    else
      all_stores = Store.where(:id => current_user.roles.where(:resource_type => "Store").pluck(:resource_id))
    end

    Store.all.each do |store|
      next if store.open_time.blank? or store.close_time.blank? or !all_stores.include? store
      open_time = Time.zone.local(current_year,current_month,current_day, store.open_time.hour , store.open_time.min)
      close_time = Time.zone.local(current_year,current_month,current_day, store.close_time.hour , store.close_time.min)
      logger.info "===========Open time[#{open_time}]============"
      logger.info "===========Close time[#{close_time}]============"
      if close_time < open_time and (current_time > open_time or current_time < close_time)
        ids << store.id
      elsif current_time.between?(open_time,close_time)
        ids << store.id
      end
    end

    @stores = Store.where(:id => ids)
  end


  #def self.kill_session
  #  session[:user_id] = nil
  #  logger.debug "killing the session======>"
  #end

  def select_store
    #authorize current_store
		logger.debug{"Epitome #{ current_store.id}" }
		c_time =  current_store.close_time
		o_time =  current_store.open_time
		d_time = o_time - c_time

		logger.debug{"#{ o_time}"}
		logger.debug{"#{c_time }"}
		logger.debug{"#{d_time }"}
		logger.debug{"#{Time.now}"}

    #min = (current_store.close_time.in_time_zone("West Central Africa").min - Time.zone.now.min)
    #StoreSelectionsController.delay(:run_at => Time.now + min).kill_session

    redirect_to dashboard_path
  end


  private

  def user_not_authorized
  	flash[:alert] = "You are not authorized to access the selected store.Speak to the PIMS admin."
    redirect_to(:back)
  end



end
