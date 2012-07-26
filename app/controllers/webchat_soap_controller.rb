class WebchatSoapController < ApplicationController  

  def get_anonymous_session_key # Für alle weiteren SOAP Funktionen wird IMMER ein SessionKey benötigt damit AACC die Kommunikation zuordnen kann
    client = get_wsdl("CIUtilityWs")
    response.to_hash = client.request(:get_anonymous_session_key)

    @session_key = response[:get_anonymous_session_key_response][:get_anonymous_session_key_result][:session_key]
    @anonymous_id = response[:get_anonymous_session_key_response][:get_anonymous_session_key_result][:anonymous_id]
  end

  def get_anonymous_customer_id(session_key, anonymous_id)
    client = get_wsdl("CIUtilityWs")
    response.to_hash = client.request(:get_anonymous_customer_id) do
      soap.body = {
        :session_key => session_key,
        :anonymous_id => anonymous_id,
        :email_address => params[:email],
        :phone_number => params[:phone]
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
        :username => username,
        :password => password
      }
    end
  end

  def get_customer_by_email_address(session_key, username)
    client = get_wsdl("CICustomerWs")
    response.to_hash = client.request(:get_customer_by_email_address) do
      soap.body = {
        :email_address => username,
        :session_key => session_key
      }
    end
    @customer_id = response[:get_customer_by_email_address_response][:get_customer_by_email_address_result][:id]
  end

  def get_skillset_by_name(session_key)
    client = get_wsdl("CISkillsetWs")
    response.to_hash = client.request(:get_skillset_by_name) do
      soap.body = {
        :skillset_name => "#{Settings.aacc.callback_skillset}",
        :session_key => session_key
      }
    end
    @skillset_id = response[:get_skillset_by_name_response][:get_skillset_by_name_result][:id]
  end

  def timestamp_to_milliseconds(hour, min, day, month, year)
    client = get_wsdl("CIUtilityWs")
    response.to_hash = client.request(:timestamp_to_milliseconds) do
      soap.body = {
        :day => day,
        :month => month,
        :year => year,
        :hour => hour,
        :minute => min,
        :second => 0,
        :utc_offset_mins => Time.zone_offset('CEST')
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
        :cust_id => cust_id,
        :skillset_id => skillset_id,
        :priority => "Priority_3_Medium_High",
        :timezone => -999,
        :text => details,
        :subject => subject,
        :session_key => session_key
      }
    end
  end

  def register_new_customer(firstname, lastname, username, password, intcode, areacode, number)
    client = get_wsdl("CICustomerWs")
    response.to_hash = client.request(:register_new_customer) do
      soap.xml = {
        '<?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
         <RegisterNewCustomer xmlns="http://webservices.ci.ccmm.applications.nortel.com">
           <newCustomer>
             <title xmlns="http://datatypes.ci.ccmm.applications.nortel.com"></title>
             <firstName xmlns="http://datatypes.ci.ccmm.applications.nortel.com">#{firstname}</firstName>
             <lastName xmlns="http://datatypes.ci.ccmm.applications.nortel.com">#{lastname}</lastName>
             <username xmlns="http://datatypes.ci.ccmm.applications.nortel.com">#{username}</username>
             <password xmlns="http://datatypes.ci.ccmm.applications.nortel.com">#{password}</password>
           </newCustomer>
           <newPhoneNumber>
             <internationalCode xmlns="http://datatypes.ci.ccmm.applications.nortel.com">#{intcode}</internationalCode>
             <areaCode xmlns="http://datatypes.ci.ccmm.applications.nortel.com">#{areacode}</areaCode>
             <number xmlns="http://datatypes.ci.ccmm.applications.nortel.com">#{number}</number>
             <phoneNumberType xmlns="http://datatypes.ci.ccmm.applications.nortel.com">Unspecified</phoneNumberType>
             <doNotCall xmlns="http://datatypes.ci.ccmm.applications.nortel.com">false</doNotCall>
             <doNotCallSpecified xmlns="http://datatypes.ci.ccmm.applications.nortel.com">false</doNotCallSpecified>
             <defaultPhoneNumber xmlns="http://datatypes.ci.ccmm.applications.nortel.com">false</defaultPhoneNumber>
             <defaultPhoneNumberSpecified xmlns="http://datatypes.ci.ccmm.applications.nortel.com">false</defaultPhoneNumberSpecified>
           </newPhoneNumber>
           <newAddress>
             <line1 xmlns="http://datatypes.ci.ccmm.applications.nortel.com"></line1>
             <line2 xmlns="http://datatypes.ci.ccmm.applications.nortel.com"></line2>
             <line3 xmlns="http://datatypes.ci.ccmm.applications.nortel.com"></line3>
             <line4 xmlns="http://datatypes.ci.ccmm.applications.nortel.com"></line4>
             <line5 xmlns="http://datatypes.ci.ccmm.applications.nortel.com"></line5>
             <zipcode xmlns="http://datatypes.ci.ccmm.applications.nortel.com"></zipcode>
             <country xmlns="http://datatypes.ci.ccmm.applications.nortel.com"></country>
             <defaultAddress xmlns="http://datatypes.ci.ccmm.applications.nortel.com">false</defaultAddress>
             <defaultAddressSpecified xmlns="http://datatypes.ci.ccmm.applications.nortel.com">false</defaultAddressSpecified>
           </newAddress>
           <newEmailAddress>
             <emailAddress xmlns="http://datatypes.ci.ccmm.applications.nortel.com">#{username}</emailAddress>
             <defaultEmailAddress xmlns="http://datatypes.ci.ccmm.applications.nortel.com">false</defaultEmailAddress>
             <defaultEmailAddressSpecified xmlns="http://datatypes.ci.ccmm.applications.nortel.com">false</defaultEmailAddressSpecified>
           </newEmailAddress>
         </RegisterNewCustomer>
        </soap:Body>
        </soap:Envelope>'
      }
    end
  end

  def update_alive_time

  end

  def close_text_chat
    
  end
end