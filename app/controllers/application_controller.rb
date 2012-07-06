class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_wsdl(interface)
    client = Savon.client("#{Settings.aacc.request_type}#{Settings.aacc.ip}/ccmmwebservices/#{interface}.asmx?wsdl") 
    return client    
  end

end
