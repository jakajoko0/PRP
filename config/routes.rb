require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # Devise Routes for Admin
  
  devise_for :admins, path: 'admins', controllers: 
  {sessions: "admins/sessions",
   registrations: "admins/registrations",
   masquerades: "admins/masquerades"}
  
  # Devise Routes for Users
  devise_for :users, path: 'users', controllers: 
  {sessions: "users/sessions",
   registrations: "users/registrations",
   masquerades: "admins/masquerades"}

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
  get '/500', :to => "errors#server_error"
  get '/cookies', :to => "cookies#index"
  
  # Routes for Signing Up
  get '/signup' => 'signups#index'
  post '/signup' => 'signups#create'

  # Authenticated route to show specific Dashboard for users
  authenticated :user do 
  	root to: 'public#userpage', as: "authenticated_user" 
    post '/' => 'public#userpage'
  end
  
  # Authenticate users before accessing these routes
  authenticate :user do  
    resources :users
    resources :franchises, only: [:edit, :update]
    resources :accountants, only: [:show]
    resources :insurances, only: [:show]
    resources :bank_accounts
    resources :credit_cards
    resources :website_preferences, except: :destroy
    resources :financials
    resources :remittances
    resources :franchise_documents, except: [:show, :edit, :update]
    resources :invoices


    get '/bank_routings/bank_name' => 'bank_routings#bank_name'
  end
  
  # Authenticated route to show specific Dashboard for admins
  authenticated :admin do 
  	root to: 'public#adminpage', as: "authenticated_admin" 
    post '/' => 'public#adminpage'
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
      resources :credits
      resources :franchise_documents
      get 'credits/audit/:id', to: "credits#audit", as: 'credit_audit'
      resources :charges
      get 'charges/audit/:id', to: "charges#audit", as: 'charge_audit'
      get 'franchises/audit/:id' ,to: "franchises#audit", as: 'franchise_audit'
      resources :accountants
      get 'accountants/audit/:id' ,to: "accountants#audit", as: 'accountant_audit'
      resources :insurances
      get 'insurances/audit/:id' ,to: "insurances#audit", as: 'insurance_audit'
      resources :website_preferences
      get 'website_preferences/audit/:id', to: "website_preferences#audit", as: 'website_preference_audit'
      resources :financials
      get 'financials/audit/:id', to: "financials#audit", as: 'financials_audit'
      resources :remittances
      get 'remittances/audit/:id', to: "remittances#audit", as: 'remittances_audit'
      resources :invoices
      get 'invoices/audit/:id', to: "invoices#audit", as: 'invoices_audit'
      resources :transaction_codes
      get '/switch_user', to: "switch_user#index"

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

        get '/website_preferences_list' => 'website_preferences_list#index'
        post '/website_preferences_list/render' => 'website_preferences_list#report'
        get '/website_preferences_list/render' => redirect('/admins/website_preferences_list')

        get '/website_preferences_missing' => 'website_preferences_missing#index'
        post '/website_preferences_missing/render' => 'website_preferences_missing#report'
        get '/website_preferences_missing/render' => redirect('/admins/website_preferences_missing')

        get '/financial_status' => 'financial_status#index'
        post '/financial_status/render' => 'financial_status#report'
        get '/financial_status/render' => redirect('/admins/financial_status')

        get '/financial_count_averages' => 'financial_count_and_averages#index'
        post '/financial_count_averages/render' => 'financial_count_and_averages#report'
        get '/financial_count_averages/render' => redirect('/admins/financial_count_averages')

        get '/financial_aggregation' => 'financial_aggregation#index'
        post '/financial_aggregation/render' => 'financial_aggregation#report'
        get '/financial_aggregation/render' => redirect('/admins/financial_aggregation')


      end

    end
  end
  
root to: 'public#main'
  
  
end
