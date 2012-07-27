class WebchatSoapController < ApplicationController  

  def get_anonymous_session_key # Für alle weiteren SOAP Funktionen wird IMMER ein SessionKey benötigt damit AACC die Kommunikation zuordnen kann
    client = get_wsdl("CIUtilityWs")
    response.to_hash = client.request(:get_anonymous_session_key)

    @session_key = response[:get_anonymous_session_key_response][:get_anonymous_session_key_result][:session_key]
    @anonymous_id = response[:get_anonymous_session_key_response][:get_anonymous_session_key_result][:anonymous_id]
  end

  def get_anonymous_customer_id
    client = get_wsdl("CIUtilityWs")
    response.to_hash = client.request(:get_anonymous_customer_id) do
      soap.body = {
        "ins0:LoginResult" => {
          "ins0:SessionKey" => "3472aJa300",            
          "ins0:AnonymousID" => "1343308799",
        },
        "ins0:EmailAddress" => "",
        "ins0:PhoneNumber" => ""
      }
    end
    @contact_id = response[:get_anonymous_customer_id_response][:get_anonymous_customer_id_result]
  end

  def send_message(session_key, contact_id, message, msgtype)
    client = get_wsdl("CIWebCommsWs")
    response.to_hash = client.request(:write_chat_message) do
      soap.body = { 
        :contact_id => contact_id,
        :message => message,
        :chat_message_type => msgtype,
        :session_key => session_key   
      }
    end  
  end

  def get_history_since(session_key, contact_id, last_read_time)
    client = get_wsdl("CIWebCommsWs")
    response.to_hash = client.request(:read_chat_message) do
      soap.body = { 
        :contact_id => contact_id,
        :session_key => session_key,
        }     
    end

    @chat_history = response[:read_chat_message_response][:read_chat_message_result]
                            [:list_of_chat_messages]
                            [:ci_chat_messages_read_type]
                            [:chat_message]
  end

  def setup_text_chat(customer_id, skillset_id, chat_query, chat_subject, custom_field, create_as_closed, session_key)
    client = get_wsdl("CICustomerWs")
    response.to_hash = client.request(:request_text_chat) do
      soap.body = {
        :cust_id => customer_id
      }
    end
  end

  def customer_login(username, password)
    client = get_wsdl("CIUtilityWs")
    response.to_hash = client.request(:customer_login) do
      soap.body = {
        "ins0:username" => "#{username}",
        "ins0:password" => "#{password}"
      }
    end
  end

  def get_customer_by_email_address(session_key, username)
    client = get_wsdl("CICustomerWs")
    response.to_hash = client.request(:get_customer_by_email_address) do
      soap.body = {
        "ins0:emailAddress" => "#{username}",
        "ins0:sessionKey" => "#{session_key}"
      }
    end
    @customer_id = response[:get_customer_by_email_address_response][:get_customer_by_email_address_result][:id]
  end

  def get_skillset_by_name(session_key)
    client = get_wsdl("CISkillsetWs")
    response.to_hash = client.request(:get_skillset_by_name) do
      soap.body = {
        "ins0:skillsetName" => "#{Settings.aacc.callback_skillset}",
        "ins0:sessionKey" => "#{session_key}"
      }
    end
    @skillset_id = response[:get_skillset_by_name_response][:get_skillset_by_name_result][:id]
  end

  def timestamp_to_milliseconds(hour, min, day, month, year)
    client = get_wsdl("CIUtilityWs")
    response.to_hash = client.request(:timestamp_to_milliseconds) do
      soap.body = {
        "ins0:timestamp" => {
          "ins1:day" => "#{day}",
          "ins1:month" => "#{month}",
          "ins1:year" => "#{year}",
          "ins1:hour" => "#{hour}",
          "ins1:minute" => "#{minute}",
          "ins1:second" => 0,
          "ins1:UTCOffsetMins" => Time.zone_offset('CEST')
        }
       }
    end
  end

  def request_scheduled_callback(session_key, cust_id, skillset_id, details, subject, time)
    client = get_wsdl("CICustomerWs")
    response.to_hash = client.request(:request_scheduled_callback) do
      soap.body = {
        :cust_id => cust_id,
        :skillset_id => skillset_id,
        :priority => "Priority_3_Medium_High",
        :timezone => -999,
        :text => details,
        :subject => subject,
        :callback_time => time,
        :session_key => session_key
      }
    end
  end

  def request_immediate_callback(session_key, cust_id, skillset_id, details, subject)
    client = get_wsdl("CICustomerWs")
    response.to_hash = client.request(:request_immediate_callback) do
      soap.body = {
        "ins0:custID" => "#{cust_id}",
        "ins0:newContact" => {
          "ins1:skillsetID" => "#{skillset_id}",
          "ins1:priority" => "Priority_3_Medium_High",
          "ins1:timezone" => -999,
          "ins1:text" => "#{details}",
          "ins1:subject" => "#{subject}"
        },
        "ins0:sessionKey" => "#{session_key}"
      }
    end
  end

  def register_new_customer(firstname, lastname, username, password, intcode, areacode, number)
    client = get_wsdl("CICustomerWs")
    response.to_hash = client.request(:register_new_customer) do
      soap.body = {
        "ins0:newCustomer" => {
          "ins1:firstName" => firstname,
          "ins1:lastName" => lastname,
          "ins1:username" => username,
          "ins1:password" => password
        },
        "ins0:newPhoneNumber" => {
          "ins1:internationalCode" => intcode,
        }
      }
    end
  end

  def update_alive_time

  end

  def close_text_chat
    
  end
end