# frozen_string_literal: true
# typed: true

require 'sidekiq/web'

# Support Class Routes
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
    get "/sign_up" => "devise/registrations#new", as: "new_user_registration" # custom path to sign_up/registration
  end

  namespace :backoffice do
    resources :home, only: [:index]

    authenticate :user, ->(user) { user.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end

    namespace :support do
      resource :unit, only: [] do
        get 'select_units_by_stock_id' => 'units#select_units_by_stock_id'
      end
    end

    namespace :application_management do
      resources :roles, except: [:show]
      resources :permissions, only: [:index]
    end

    namespace :organization_management do
      resources :organization_profiles, only: [] do
        get '' => 'organization_profiles#edit', as: :edit, on: :collection
        put '' => 'organization_profiles#update', as: :update, on: :collection
        patch '' => 'organization_profiles#update', on: :collection
      end
      resources :organizations, except: [:show] do
        delete 'unselect' => 'organizations#unselect', as: 'unselect', on: :collection
        member do
          post 'select' => 'organizations#select', as: 'select'
        end
      end
    end

    namespace :user_settings do
      resources :users, except: [:show] do
        collection do
          get 'profile' => 'users#edit_profile', as: :edit_profile
          patch 'profile' => 'users#update_profile', as: :update_profile
          get 'security' => 'passwords#edit', as: :edit_security
          patch 'security' => 'passwords#update', as: :update_security
        end
      end
    end

    namespace :stock_management do
      get 'backoffice/stock_management', to: 'backoffice/stock_management/stocks#index'

      resources :outputs, except: [:show]
      resources :entries, except: [:show]
      resources :stocks, except: [:show]
    end

    namespace :catalogs_management do
      get 'backoffice/catalogs_management', to: 'backoffice/catalogs_management/products#index'

      resources :catalog_categories, except: [:show]
      resources :products, except: [:show] do
        post 'calculate_prices' => 'products#calculate_prices', on: :collection, as: :calculate_prices
        member do
          post 'recalculate_prices' => 'products#recalculate_prices', as: :recalculate_prices
          get 'calculate_profit_price/(:profit_rate)' => 'products#calculate_profit_price', as: :calculate_profit_price
        end
      end
      resources :items, only: [], param: :index do
        member do
          delete '(:id)' => 'items#destroy', as: 'destroy'
          post 'new' => 'items#new', as: 'new'
        end
      end
    end

    namespace :sales_management do
      get 'backoffice/sales_management', to: 'backoffice/sales_management/product_sales#index'

      resources :product_sales, except: [:show]
      resources :product_sale_items, only: [], param: :index do
        member do
          delete '(:id)' => 'product_sale_items#destroy', as: 'destroy'
          post 'new' => 'product_sale_items#new', as: 'new'
        end
      end
    end

    get '/403', to: 'errors#forbidden', via: :all, as: :forbidden
    get '/404', to: 'errors#not_found', via: :all, as: :not_found
    get '/406', to: 'errors#unacceptable', via: :all, as: :unacceptable
    get '/500', to: 'errors#internal_error', via: :all, as: :internal_server_error
  end

  scope module: :site do
    resources :home, only: [:index]
    resources :menu, only: [:index]
    resources :about, only: [:index]
    resources :service, only: [:index]
    resources :contacts, only: [:index]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'backoffice', to: 'backoffice/home#index'
  get 'backoffice/business-manager', to: 'backoffice/home#index'

  # Devise
  devise_for :users, skip: [:registrations]
  unauthenticated do
    root 'site/home#index'
  end

  authenticated :user do
    root 'backoffice/home#index', as: :authenticated_root
  end
end
