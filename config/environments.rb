require 'sinatra'

# Load components configuration
configure :production, :development do
  environment = ENV['RACK_ENV'] || 'development'
  db_config = YAML.load(File.read("config/database.yml"))
  ActiveRecord::Base.establish_connection(db_config[environment])

  iothub_config = YAML.load(File.read("config/iothub.yml"))
  iothub_options = IotHubOptions.new(iothub_config[environment])
  set :iothub_options, iothub_options

  smartplug_config = YAML.load(File.read("config/smartplug.yml"))
  smartplug_options = SmartplugOptions.new(smartplug_config[environment])
  set :smartplug_options, smartplug_options
end