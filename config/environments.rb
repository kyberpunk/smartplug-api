require 'sinatra'

configure :production, :development do
  environment = ENV['RACK_ENV'] || 'development'
  db_config = YAML.load(File.read("config/database.yml"))
  ActiveRecord::Base.establish_connection(db_config[environment])

  iothub_config = YAML.load(File.read("config/iothub.yml"))
  iothub_options = IotHubOptions.new(iothub_config[:connection_string])
  iothub_options.expiry = iothub_config[:expiry]

  set :iothub_options, iothub_options

  smartplug_options = SmartplugOptions.new
  smartplug_options.connect_timeout = 5
  smartplug_options.direct_data_duration = 30
  smartplug_options.direct_data_timeout = 10
  smartplug_options.response_timeout = 5

  set :smartplug_options, smartplug_options
end