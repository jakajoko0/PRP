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
      get 'collections_by_month'
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
    resources :accountants, only: [:index,:show]
    resources :insurances, only: [:show]
    resources :bank_accounts
    resources :credit_cards
    resources :website_preferences, except: :destroy
    resources :insurances, only: :show
    resources :financials
    resources :remittances
    post '/remittances/new' => 'remittances#new'
    resources :franchise_documents, except: [:show, :edit, :update]
    resources :invoices
    resources :deposit_trackings
    resources :bank_payments
    resources :card_payments 
    resources :check_payments
    resources :franchises_users

    get '/franchise_directory' => 'franchise_directory#index'
    get '/bank_routings/bank_name' => 'bank_routings#bank_name'
    get '/payments' => 'payments#index'
    get '/payments/refresh_partial' => 'payments#refresh_partial', as: 'refresh_partial'
    get '/payment_review' => 'payment_review#index'
    post '/payment_review' => 'payment_review#index'

    scope module: :reports do 
      #Statement
      get '/statement' => 'statements#index'
      post '/statement/render' => 'statements#report'
      get '/statement/render' => redirect('/statement')

      #Payments report
      get '/payment_report' => 'payment_report#index'
      post '/payment_report/render' => 'payment_report#report'
      get '/payment_report/render' => redirect('/payment_report')
    end
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
      get '/' => 'public#adminpage'
      resources :users
      resources :admins
      resources :franchises
      resources :franchises_select
      resources :credits
      resources :franchise_documents
      resources :franchises_users
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
      resources :check_payments
      resources :bank_payments
      resources :card_payments

      get 'website_payment_list' => 'website_payment_list#index'
      get 'website_payments' => 'website_payments#index'
      get '/receipts', to: "receipts#index"
      get '/payments', to: "payments#index"
      get '/payment_review' => 'payment_review#index'
      post '/payment_review' => 'payment_review#index'
      get '/pending_payments' => 'pending_payments#index'
      get '/declined_payments' => 'declined_payments#index'
      get '/approved_payments' => 'approved_payments#index'
      post '/approved_payments' => 'approved_payments_review#index'
      get '/activity_review' =>'activity_reviews#index'
      post '/activity_review' => 'activity_reviews#index'
      get '/event_logs' => 'event_logs#index'
      post '/event_logs' => 'event_logs#index'
      get '/audit_trail' => 'audits#index'
      post '/audit_trail' => 'audits#index'
      #Reports
      scope module: :reports do 
        #Franchise List
        get '/statement_date' => 'statements#update_date'
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

        get '/payment_report' => 'payment_report#index'
        post '/payment_report/render' => 'payment_report#report'
        get '/payment_report/render' => redirect('/admins/payment_report')

        get '/insurance_missing' => 'insurance_missing#index'
        post '/insurance_missing/render' => 'insurance_missing#report'
        get '/insurance_missing/render' => redirect('/admins/insurance_missing')

        get '/payment_methods' => 'payment_methods#index'
        post '/payment_methods/render' => 'payment_methods#report'
        get '/payment_methods/render' => redirect('/admins/payment_methods')

        get 'payment_methods_missing' => 'payment_methods_missing#index'
        post '/payment_methods_missing/render' => 'payment_methods_missing#report'
        get '/payment_methods_missing/render' => redirect('/admins/payment_methods_missing')

        get '/statement' => 'statements#index'
        post '/statement/render' => 'statements#report'
        get '/statement/render' => redirect('/admins/statement')

        get '/transaction_summary' => 'transaction_summary#index'
        post '/transaction_summary/render' => 'transaction_summary#report'
        get '/transaction_summary/render' => redirect('/admins/transaction_summary')

        get '/transaction_detail' => 'transaction_detail#index'
        post '/transaction_detail/render' => 'transaction_detail#report'
        get '/transaction_detail/render' => redirect('/admins/transaction_detail')


        get '/amounts_due' => 'amounts_due#index'
        post '/amounts_due/render' => 'amounts_due#report'
        get 'amounts_due/render' => redirect('admins/amounts_due')

        get '/delinquent_report' => 'delinquents#index'
        post '/delinquent_report/render' => 'delinquents#report'
        get '/delinquent_report/render' => redirect('admins/delinquent_report')

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
