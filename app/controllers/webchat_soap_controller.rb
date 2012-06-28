class WebchatSoapController < ApplicationController
  extend Savon::Model

  document "#{Settings.aacc.request_type}#{Settings.aacc.ip}/ccmmwebservices/CIUtilityWs.asmx?wsdl"   

  def get_anonymous_customer_id(id)
    response = client.request(:get_anonymous_customer_id) do
      soap.body = { id: id }
    end
  end

  def get_anonymous_session_key
    #response = client.request(:get_anonymous_session_key)
    #result = response.to_hash('SessionKey' => response[GetAnonymousSessionKeyResult][SessionKey], 'AnnoymousID' => $response[GetAnonymousSessionKeyResult][AnonymousID])

  end

  def send_message
    
  end

  def refresh_history
    
  end

  def update_alive_time

  end

  def setup_text_chat
    
  end

  def close_text_chat
    
  end

  def request_callback_now
      
  end

  def request_callback_later
      
  end  
end