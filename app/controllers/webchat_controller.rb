class WebchatController < ApplicationController

### SITES #############
  def start    
  end

  def start_after_question    
  end

  def request_callback   
  end
#######################


### GROUP FUNCTIONS ###

  def callback_scheduled(caller_name, caller_number, hour, min, day, month, year)
    firstname = "ContactCenter"
    lastname = "Anonymous"
    username = time.now
    password = time.now
    number = caller_number

    WebchatSoapController.register_new_customer(lastname, username, password, "", "", number)

    session_key = WebchatSoapController.login(username, password)
    cust_id = WebchatSoapController.get_customer_id(session_key, username)
    skillset_id = WebchatSoapController.get_skillset_by_name(session_key)
    millisecond = WebchatSoapController.convert_timestamp_to_milliseconds(hour, min, day, month, year)

    WebchatSoapController.request_callback_later(session_key, cust_id, skillset_id, caller_name, "Website CallBack", millisecond)
    
  end

  def callback_now(caller_name, caller_number)
    firstname = "ContactCenter"
    lastname = "Anonymous"
    username = time.now
    password = time.now
    number = caller_number

    WebchatSoapController.register_new_customer(lastname, username, password, "", "", number)

    session_key = WebchatSoapController.customer_login(username, password)
    cust_id = WebchatSoapController.get_customer_by_email_address(session_key, username)
    skillset_id = WebchatSoapController.get_skillset_by_name(session_key)
    
    WebchatSoapController.request_callback_now(session_key, cust_id, skillset_id, caller_name, "Website CallBack")

  end
#######################
end