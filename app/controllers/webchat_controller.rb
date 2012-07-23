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

  def request_callback_scheduled(caller_name, caller_number, hour, min, day, month, year)
    firstname = "ContactCenter"
    lastname = "Anonymous"
    username = time.now
    password = time.now
    number = caller_number

    register_new_customer(lastname, username, password, "", "", number)

    session_key = login(username, password)
    cust_id = get_customer_id(session_key, username)
    skillset_id = get_skillset_by_name(session_key)
    millisecond = convert_timestamp_to_milliseconds(hour, min, day, month, year)

    request_callback_later(session_key, cust_id, skillset_id, caller_name, "Website CallBack", millisecond)
    
  end

  def request_callback_now
    firstname = "ContactCenter"
    lastname = "Anonymous"
    username = "test"
    password = "test"
    number = "0566339641"

    register_new_customer(firstname, lastname, username, password, "", "", number)

    session_key = customer_login(username, password)
    cust_id = get_customer_by_email_address(session_key, username)
    skillset_id = get_skillset_by_name(session_key)
    
    request_immediate_callback(session_key, cust_id, skillset_id, "Patrick", "Website CallBack")

  end
#######################
end