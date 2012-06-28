jQuery ->
  processInput = ->

    # get input
    username = $('#username').val
    email = $('#email').val
    phone = $('#phone').val
    skillset = $('#skillset').val

    # username as first name when creating user in db
    FirstName = username

    # get session key
    SessionKey = $.get('soap/get_anonymous_session_key')

    # get customer id
    CustomerID = $.get('soap/get_and_update_anonymous_customer_id')








