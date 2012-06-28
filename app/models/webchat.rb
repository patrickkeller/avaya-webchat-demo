class Webchat
  extend Savon::Model

  document "#{Settings.aacc.request_type}#{Settings.aacc.ip}/ccmmwebservices/CIUtilityWs.asmx?wsdl"
end