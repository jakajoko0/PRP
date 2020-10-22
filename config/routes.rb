require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # Devise Routes for Admin
  devise_for :admins, path: 'admins', controllers: 
  {sessions: "admins/sessions",
   registrations: "admins/registrations"}
  
  # Devise Routes for Users
  devise_for :users, path: 'users', controllers: 
  {sessions: "users/sessions",
   registrations: "users/registrations"}

  resources :charts, only:[] do 
    collection do 
      get 'all_royalties_by_month'
      get 'revenue_by_state'
      get 'collections_by_category'
    end
  end
  
  # Custom Routes for Errors
  get '/404', :to => "errors#not_found"
  get '/422', :to => "errors#unacceptable"
  #get '/500', :to => "errors#server_error"
  
  # Routes for Signing Up
  get '/signup' => 'signups#index'
  post '/signup' => 'signups#create'

  # Authenticated route to show specific Dashboard for users
  authenticated :user do 
  	root to: 'public#userpage', as: "authenticated_user" 
  end
  
  # Authenticate users before accessing these routes
  authenticate :user do  
    resources :users
    resources :franchises, only: [:edit, :update]
    resources :accountants, only: [:show]
    resources :insurances, only: [:show]
    resources :bank_accounts
    resources :credit_cards

    get '/bank_routings/bank_name' => 'bank_routings#bank_name'
  end
  
  # Authenticated route to show specific Dashboard for admins
  authenticated :admin do 
  	root to: 'public#adminpage', as: "authenticated_admin" 
  end
  
  # Authenticate admins before accessing these routes
  authenticate :admin do 
    mount Logster::Web, at: "/logs"
    mount Sidekiq::Web => '/sidekiq'
    # Namespace the Admin pages
    namespace :admins do 
      resources :users
      resources :admins
      resources :franchises
      resources :franchises_select
      get 'franchises/audit/:id' ,to: "franchises#audit", as: 'audit'
      resources :accountants
      resources :insurances


      #Reports
      scope module: :reports do 
        #Franchise List
        get '/franchise_list' => 'franchise_list#index'
        post '/franchise_list/render' => 'franchise_list#report'
        get '/franchise_list/render' => redirect('/admins/franchise_list')

        get '/franchise_expiration' => 'franchise_expiration#index'
        post '/franchise_expiration/render' => 'franchise_expiration#report'
        get '/franchise_expiration/render' => redirect('/admins/franchise_expiration')

        get '/franchise_advanced_rebate' => 'franchise_advanced_rebate#report'
        post '/franchise_advanced_rebate' => 'franchise_advanced_rebate#report'

        get '/franchise_prior_rebate' => 'franchise_prior_rebate#report'
        post '/franchise_prior_rebate' => 'franchise_prior_rebate#report'

        get '/insurance_expiration' => 'insurance_expiration#index'
        post '/insurance_expiration/render' => 'insurance_expiration#report'
        get '/insurance_expiration/render' => redirect('/admins/insurance_expiration')

        get '/insurance_missing' => 'insurance_missing#index'
        post '/insurance_missing/render' => 'insurance_missing#report'
        get '/insurance_missing/render' => redirect('/admins/insurance_missing')

        get '/payment_methods' => 'payment_methods#index'
        post '/payment_methods/render' => 'payment_methods#report'
        get '/payment_methods/render' => redirect('/admins/payment_methods')

        get 'payment_methods_missing' => 'payment_methods_missing#index'
        post '/payment_methods_missing/render' => 'payment_methods_missing#report'
        get '/payment_methods_missing/render' => redirect('/admins/payment_methods_missing')


      end

    end
  end
  
root to: 'public#main'
  
  
end
