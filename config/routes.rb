Rails.application.routes.draw do

  resources :alerts do
    collection do
      get 'mark_all_as_read'
      get 'clear'
    end
  end

  resources :pims_configs

  resources :receipts do
    collection do
      post 'filter'
      post 'confirm'
      get 'lost_drugs'
      get 'order_receipt'
      get 'generate_pdf'
    end
  end

  resources :inventory do
    collection do
      post 'filter'
      post 'import'
      get 'rate'
    end
    member do

    end
  end

  resources :request_items

  resources :requests

  resources :surcharges do
    collection do
      get 'active'
    end
  end


  resources :roles, only: [:index, :edit, :update, :new, :destroy, :create]

  resources :approvals do
    collection do
      get 'approval_index'
    end
    member do
      get 'submitted_item'
    end
  end

  resources :patients do
    collection do
      post :filter
    end
  end

  resources :prescriptions do
    collection do
      get 'search'
      get 'collate'
      get 'dispense'
    end
    member do
      post 'complete_collation'
      post 'complete_dispense'
    end
  end

  resources :supplies do
    collection do
      get 'service_request'
      get 'show_form'
      get 'hide_form'
      post 'order'
      post 'filter_service_requests'
      post 'filter_transfer_drugs'
      post 'filter_expired_drugs'
      post 'transfer_batches'
      post 'transfer_batches_v2'
      get 'transfer_drugs'
      get 'expired_drugs'
      get 'existing_order'
      match 'search', via: [:get, :post]
    end
    member do
      patch 'submit'
      post 'approval'
    end
  end


  resources :batches do
    collection do
      get 'ramp_up'
    end
  end

  resources :hospital_units

  resources :pharm_items

  resources :brands


  resource :dashboard, only: :show

  get 'front_pages/home'

  get 'front_pages/features'

  get 'front_pages/help_doc'

  resources :staff_categories

  resources :marketers

  resources :item_concentration_units

  resources :item_classes

  resources :organisations

  resources :store_operations

  resources :store_types

  resources :unit_doses

  resources :vendors do
    collection do
      post "order"
    end
  end

  devise_for :users, :controllers => {:registrations => "pims_devise/registrations", :sessions => "pims_devise/sessions"}

  resources :users, :only => [:edit, :index, :update, :destroy, :show, :password_change] do
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
      post :set_active_store
    end
  end

  root :to => 'front_pages#home'

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

end
