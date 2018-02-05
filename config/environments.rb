configure :production, :development do
  environment = ENV['RACK_ENV'] || 'development'
  db_config = YAML.load(File.read("config/database.yml"))

  ActiveRecord::Base.establish_connection(db_config[environment])
end