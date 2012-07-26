AvayaWebchatDemo::Application.routes.draw do

    resources :welcome, :only => [:index]


    ### SITES ROUTING ###
    scope "/webchat" do
      get 'start',                        to: 'webchat#start',                          as: 'start_webchat'
      get 'start_after_question',         to: 'webchat#start_after_question',           as: 'start_webchat_after_question'
      get 'callback_now',                 to: 'webchat#callback_now',                   as: 'callback_now'
      get 'callback_scheduled',           to: 'webchat#callback_scheduled',             as: 'callback_scheduled'

    ### GROUP FUNCTIONS ###
      get 'request_callback_now',         to: 'webchat#request_callback_now',           as: 'request_callback_now'        
      get 'request_callback_later',       to: 'webchat#request_callback_later',         as: 'request_callback_later'
    end

    ### SOAP FUNCTIONS ###
    scope "/webchat/soap" do
      # WEBCHAT
      get 'get_anonymous_customer_id',    to: 'webchat_soap#get_anonymous_customer_id', as: 'get_anonymous_customer_id'
      get 'get_anonymous_session_key',    to: 'webchat_soap#get_anonymous_session_key', as: 'get_anonymous_session_key'
      get 'send_message',                 to: 'webchat_soap#send_message',              as: 'send_message'
      get 'refresh_history',              to: 'webchat_soap#refresh_history',           as: 'refresh_history'
      get 'update_alive_time',            to: 'webchat_soap#update_alive_time',         as: 'update_alive_time'
      get 'setup_text_chat',              to: 'webchat_soap#setup_text_chat',           as: 'setup_text_chat'
      get 'close_text_chat',              to: 'webchat_soap#close_text_chat',           as: 'close_text_chat' 
      # CALLBACK
      get 'register_new_customer',        to: 'webchat_soap#register_new_customer',     as: 'register_new_customer'  
      get 'customer_login',               to: 'webchat_soap#customer_login',            as: 'customer_login'
      get 'get_customer_by_email',        to: 'webchat_soap#get_customer_by_email',     as: 'get_customer_by_email'
      get 'get_skillset_by_name',         to: 'webchat_soap#get_skillset_by_name',      as: 'get_skillset_by_name'
      get 'request_immediate_callback',   to: 'webchat_soap#request_immediate_callback',as: 'request_immediate_callback'
    end

  root :to => 'welcome#index'

end