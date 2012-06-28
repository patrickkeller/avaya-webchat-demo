

function removeUnwantedChars(str)
{
  var temp = str;
  var Pattern="<>[];";
  for ( i = 0; i < Pattern.length; i++ ) 
  {
      str = str.replace(Pattern[i], "");
  }
  
  if(temp != str)
  {
  alert("Tag's <>[]; are not allowed");
  }
  
  return str; 
}

function processInput()
{
  //get input
  var username = removeUnwantedChars(document.getElementById('username').value);
  var email    = removeUnwantedChars(document.getElementById('email').value);
  var phone    = removeUnwantedChars(document.getElementById('phone').value);
  var skillset = removeUnwantedChars(document.getElementById('skillset').value);
  
  //------- other usable input objects
  var AddressLine1 = "";
  var AddressLine2 = "";
  var AddressLine3 = "";
  var AddressLine4 = "";
  var AddressLine5 = "";
  var AddressCountry = "";
  var AddressLineZipcode = "";
  var FirstName = "";
  var LastName = "";
  var Title = "";
  var WebCommsSubject = "";
  var CustomField_1_Name = "";
  var CustomField_1_Value = "";
  var WebCommsQuery = "";
  //----------------------------------
  
  //user username as first name when creating user in database
  FirstName = username;
  
  //start to look for errors
  var error = false;
  
  document.getElementById('EmailError').innerHTML = "";
  document.getElementById('PhoneError').innerHTML = "";
  
  //validate email address
  if(email != "")
  {
    if(!ValidEmailAddress(email))
    {
      document.getElementById('EmailError').innerHTML = "<font color='red'>Email Address is not valid</font>";
      error = true;
    }
  }
  
  //validate phone number
  if(!ValidPhoneNumber(phone))
  {
    document.getElementById('PhoneError').innerHTML = "<font color='red'>Phone Number is not valid</font>";
    error = true;
  }
  
  //any errors?
  if(error)
  {
    return;
  }
  
  //hide user input panel
  document.getElementById('webchat_user_input').style.display = "none";
  
  //show loading panel while we do all the web service calls and it can take a few seconds to complete
  document.getElementById('webchat_please_wait').style.display = "block";
  

  //get session key
  var result = jqSajax.x_GetAnnoymousSessionKey("<?php echo $home?>");
  SessionKey = result.SessionKey;
  
  if(SessionKey == null)
  {
    //disaply error - usuall cause is the chat cannot connect to the CCMM server - check config for server name
  document.getElementById('PleaseWait').innerHTML = "Error : Unable to Connect to Agent<br \>Reason : Unable to get Session Key";
  return;
  }

  
  //get customer ID

  var CustomerID = jqSajax.x_GetAndUpdateAnnoymousCustomerID(SessionKey, result.AnnoymousID, email, phone, FirstName, LastName, Title, AddressLine1, AddressLine2, AddressLine3, AddressLine4, AddressLine5, AddressCountry, AddressLineZipcode, "<?php echo $home?>")

  if(CustomerID == -1)
  {
    //try remove phone number (known bug)
  CustomerID = jqSajax.x_GetAndUpdateAnnoymousCustomerID(SessionKey, result.AnnoymousID, email, "", FirstName, LastName, Title, AddressLine1, AddressLine2, AddressLine3, AddressLine4, AddressLine5, AddressCountry, AddressLineZipcode, "<?php echo $home?>")

  if(CustomerID == -1)
    {
      //can happen when ImpersonateCustomer is disabled
    document.getElementById('PleaseWait').innerHTML = "Error : Unable to Connect to Agent<br \>Reason : Unable to get valid Customer ID";
    return;
  }
  }
  
  //get skillset Id from name
  var SkillsetID = jqSajax.x_ReadSkillsetByName(SessionKey, skillset, "<?php echo $home?>");
  if(SkillsetID == null)
  {
  //can happen when an invalid skillset name is used
  document.getElementById('PleaseWait').innerHTML = "Error : Unable to Connect to Agent<br \>Reason : Unable to get Skillset ID";
  return;
  }
  
  //request text chat
  showAgentWin(username, SkillsetID, CustomerID, SessionKey, email, phone, WebCommsSubject, CustomField_1_Name, CustomField_1_Value, WebCommsQuery);
  
  return;
}

function ValidEmailAddress(str)
{  
  var at="@"
  var dot="."
  var lat=str.indexOf(at)
  var lstr=str.length
  var ldot=str.indexOf(dot)

  if (str.indexOf(at)==-1)
  {
    return false
  }

  if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr)
  {
    return false
  }

  if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr)
  {
    return false
  }

  if (str.indexOf(at,(lat+1))!=-1)
  {
    return false
  } 

  if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot)
  {
    return false
  }

  if (str.indexOf(dot,(lat+2))==-1)
  {
    return false
  }
    
  if (str.indexOf(" ")!=-1)
  {
    return false
  }

  return true         
}

function ValidPhoneNumber(str)
{
  var ValidChars = "0123456789";
  var IsNumber=true;
  var Char;

  for (i = 0; i < str.length && IsNumber == true; i++) 
  { 
    Char = str.charAt(i); 
    if (ValidChars.indexOf(Char) == -1) 
    {
      IsNumber = false;
    }
  }
  return IsNumber;
}
