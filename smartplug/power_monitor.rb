require 'helper'

# This class provides method for plug electrical power measurement.
class PowerMonitor
  def initialize(options, device_manager, twin_manager)
    @options = options
    @device_manager = device_manager
    @twin_manager = twin_manager
  end

  # Get the latest measured data
  def get_direct_data(device_id)
    twin = @twin_manager.get_twin(device_id)
    # this code is only for start method calling on backend without client concerns
    # timeout = Time.iso8601(twin.properties.desired[:directDataTimeout])
    # if !timeout || (timeout - Time.utc).to_i.abs <= 5
    #  start_direct_data(device_id)
    #  twin.properties.desired[:directDataTimeout] = timeout + @options.direct_data_timeout
    #  twin = @twin_manager.update_twin(twin)
    # end
    DirectData.create(twin)
  end

  # Force device to start sending direct data
  def start_direct_data(device_id)
    method = DirectMethod.new
    method.response_timeout = @options.response_timeout
    method.connect_timeout = @options.connect_timeout
    method.payload = { timeout: @options.direct_data_timeout }
    method.method_name = :startdirectdata
    @twin_manager.invoke_method(device_id, method)
    nil
  end
end