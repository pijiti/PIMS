Rails.application.routes.draw do

  resources :request_items

  resources :requests

  resources :surcharges, only: [:index,:edit,:create,:update,:destroy,:new] do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :roles, only: [:index,:edit,:update,:new,:destroy,:create]

  resources :approvals  do
  	collection do
  		get 'approval_index'
  	end
  	member do
  		get 'submitted_item'
  	end
  end

	resources :patients

	resources :prescriptions do
	 collection do
	 	get 'excel_index'
	 	get 'search'
	 end
	end

	 resources :supplies do
  		collection do
  			get 'show_form'
  			get 'hide_form'
  			match 'search', via: [:get,:post]
  		end
  		member do
  			patch 'submit'
  		end
  end


  resources :batches do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :hospital_units do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :pharm_items do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :brands



  resource :dashboard, only: :show

  get 'front_pages/home'

  get 'front_pages/features'

  get 'front_pages/help_doc'

  resources :staff_categories do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :marketers do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :item_concentration_units do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :item_classes do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :organisations

  resources :store_operations do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :store_types do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :unit_doses do
  	collection do
	 	get 'excel_index'
	 end
  end

  resources :vendors do
  	collection do
	 	get 'excel_index'
	 end
  end

  devise_for :users, :controllers =>{:registrations => "pims_devise/registrations" ,:sessions => "pims_devise/sessions"}

  resources :users, :only => [:edit,:index,:update,:destroy,:show,:password_change] do
  	member do
         patch 'password_reset'
         get 'password_edit'
         patch 'password_change'
    end
  end

  resources :user_profiles

  get 'store_selections/index'
  post 'store_selections/select_store'

  resources :stores do
  	collection do
	 	get 'excel_index'
	 end
  end

  root :to => 'front_pages#home'

end
