# Smartplug library options
class SmartplugOptions
  attr_accessor :response_timeout
  attr_accessor :connect_timeout
  attr_accessor :direct_data_duration
  attr_accessor :direct_data_timeout

  # Set config options
  def initialize(options = nil)
    return unless options
    options = options.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    @response_timeout = options[:response_timeout]
    @connect_timeout = options[:connect_timeout]
    @direct_data_duration = options[:direct_data_duration]
    @direct_data_timeout = options[:direct_data_timeout]
  end
end