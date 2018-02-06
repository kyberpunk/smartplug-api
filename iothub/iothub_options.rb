# Model for parsing Iot Hub connection string
class IotHubOptions
  attr_accessor :key_name
  attr_accessor :key
  attr_accessor :host
  attr_accessor :expiry

  def initialize(options = nil)
    return unless options
    options = options.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    match = options[:connection_string].match(/HostName=(.*);SharedAccessKeyName=(.*);SharedAccessKey=(.*)/)
    if match.captures
      @host, @key_name, @key = match.captures
    end
    @expiry = options[:expiry]
  end
end