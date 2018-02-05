# Model for parsing Iot Hub connection string
class IotHubOptions
  attr_accessor :key_name
  attr_accessor :key
  attr_accessor :host
  attr_accessor :expiry

  def initialize(connection_string)
    match = connection_string.match(/HostName=(.*);SharedAccessKeyName=(.*);SharedAccessKey=(.*)/)
    if match.captures
      @host, @key_name, @key = match.captures
      @expiry = 3600
    end
  end
end