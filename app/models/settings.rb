class Settings < Settingslogic
  source "#{Rails.root}/app/models/settings.yml"
  namespace Rails.env
end