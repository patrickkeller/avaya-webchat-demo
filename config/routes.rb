AvayaWebchatDemo::Application.routes.draw do

    resources :welcome, :only => [:index]

    scope "/webchat" do
      get 'start',                        to: 'webchat#start',                          as: 'start_webchat'
      get 'start_after_question',         to: 'webchat#start_after_question',           as: 'start_webchat_after_question'
      get 'callback',                     to: 'webchat#callback',                       as: 'callback'
    end

    scope "/webchat/soap" do
      get 'get_anonymous_customer_id',    to: 'webchat_soap#get_anonymous_customer_id', as: 'get_anonymous_customer_id'
      get 'get_anonymous_session_key',    to: 'webchat_soap#get_anonymous_session_key', as: 'get_anonymous_session_key'
      get 'send_message',                 to: 'webchat_soap#send_message',              as: 'send_message'
      get 'refresh_history',              to: 'webchat_soap#refresh_history',           as: 'refresh_history'
      get 'update_alive_time',            to: 'webchat_soap#update_alive_time',         as: 'update_alive_time'
      get 'setup_text_chat',              to: 'webchat_soap#setup_text_chat',           as: 'setup_text_chat'
      get 'close_text_chat',              to: 'webchat_soap#close_text_chat',           as: 'close_text_chat'
      get 'request_callback_now',         to: 'webchat_soap#request_callback_now',      as: 'request_callback_now'        
      get 'request_callback_later',       to: 'webchat_soap#request_callback_later',    as: 'request_callback_later'
    end

    

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     
  #
  #     collection do
  #       get 'sold'
  #     
  #   

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     
  #   

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end