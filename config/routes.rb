Ispweb::Application.routes.draw do
  resources :customer_bandwidths
  resources :mikrotiks
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
  resources :categories
  resources :equipment
 # get "new_equipment" => "equipment#new", :as => "new_equipment"
  resources :makes do
    resources :models
  end
    resources :plans
    resources :suppliers
    resources :locations
    resources :permissions
    resources :roles do
        resources :roles_and_permissions
    end
    resources :customers do
      resources :loans
      resources :tickets do
     #   resources :tickets_answers
      end
      resources :account_receivables
      resources :ips
      resources :customer_payment_accounts
      match "reply/:id/edit"=> "tickets#reply", as: :reply
      match "history_ticket/:id" =>"tickets#history_ticket", as: :history_ticket
      resources :invoices

 end
    match "technical_visit" =>"tickets#technical_visit", as: :technical_visit
    match "invoice" => "invoices#close_invoice"
 #    devise_for :users, :controllers => {:registrations => :registrations}

    devise_for :users
    resources :users
    match '*path', to: redirect("/#{I18n.default_locale}/%{path}")
    match '', to: redirect("/#{I18n.default_locale}")
end
    match "models" => "models#index"
    match "loans" => "loans#loan_pending"
    match "tickets"=>"tickets#all"
    match "customer_band" => "customer_bandwidths#load_customers"
    
    # match "users" => "users#index"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  # match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  # resources :products

  # Sample resource route with options:
  # resources :products do
  # member do
  # get 'short'
  # post 'toggle'
  # end
  #
  # collection do
  # get 'sold'
  # end
  # end

  # Sample resource route with sub-resources:
  # resources :products do
  # resources :comments, :sales
  # resource :seller
  # end

  # Sample resource route with more complex sub-resources
  # resources :products do
  # resources :comments
  # resources :sales do
  # get 'recent', :on => :collection
  # end
  # end

  # Sample resource route within a namespace:
  # namespace :admin do
  # # Directs /admin/products/* to Admin::ProductsController
  # # (app/controllers/admin/products_controller.rb)
  # resources :products
  # end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  authenticated :user do
  root :to => 'tickets#all'
end
unauthenticated :user do
  devise_scope :user do
    get "/" => "devise/sessions#new"
  end
  end


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
