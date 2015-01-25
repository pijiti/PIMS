class RequestsController < ApplicationController
	before_action :set_request, only: [:edit,:destroy,:update]
	before_action :set_requests, only: [:index]
	def index
		@batches =  Batch.where("recipient_store = ? ", session[:active_store] )

   new
	end

	def new
		@request = Request.new
		10.times do
			request_items = @request.request_items.new
				2.times {request_items.try(:batches).try(:new)}
		end
	end

	def edit

	end

	def create
		@request = Request.new(request_params)
		if @request.save
			redirect_to requests_path
		else
			render new
		end
	end

	def update
		if @request.update_attributes(request_params)
			 @request.request_items.try(:collect){|request_item| [request_item.batches.try(:collect){|batch| [batch.pharm_item_id = batch.try(:brand).try(:pharm_item).try(:id)]}]}
			redirect_to requests_path
		else
			render edit
		end
	end

	def destroy
		@request = Request.destroy
		 redirect_to requests_path
	end

	private
	def set_request
		@request = Request.find(params[:id])
	end

	def set_requests
		@requests =  Request.all
	end

	def request_params
		params.require(:request).permit(:request_code,:store_id,:user_id,:workflow_state,
		                                              request_items_attributes: [:id,:pharm_item_id,:qty,:comments,
		                                              	batches_attributes: [:id,:brand_id,:pharm_item_id,:batch_number,:qty,:comment]])
	end
end
