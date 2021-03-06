require 'helper'

# Manager class provides basic methods for smartplug control.
class SmartplugManager
  def initialize(options, device_manager, twin_manager)
    @options = options
    @device_manager = device_manager
    @twin_manager = twin_manager
  end

  # Get information about smartplug device state
  def get_smartplug(device_id)
    device = @device_manager.get_device(device_id)
    return null unless device
    twin = @twin_manager.get_twin(device_id)
    SmartplugDevice.create(device, twin)
  end

  # Switch smartplug relay
  def switch(device_id, value)
    method = init_method('switch')
    method.payload = { switchOn: value }
    @twin_manager.invoke_method(device_id, method)
  end

  # Invoke device firmware update
  def update_firmware(device_id, version)
    plug = get_smartplug(device_id)
    if plug.firmware_status == :Running
      raise InvalidOperationError, 'Update is already running'
    end
    if plug.actual_firmware_version == version
      raise InvalidOperationError, 'Device is already on this version'
    end
    method = init_method(:fwupdate)
    method.payload = { version: version }
    @twin_manager.invoke_method(device_id, method)
    @twin_manager.update_twin_properties(device_id, latestFirmwareVersion: version)
  end

  # Force device to reset its properties
  def reset(device_id)
    twin = @twin_manager.get_twin(device_id)
    twin.properties.desired[:latestFirmwareVersion] = twin.properties.reported[:actualFirmwareVersion]
    counter = twin.properties.desired[:twinResetCounter]
    if twin.properties.desired[:twinResetCounter]
      twin.properties.desired[:twinResetCounter] = counter.to_i + 1
    elsif counter != twin.properties.reported[:twinResetCounter]
      twin.properties.desired[:twinResetCounter] = 1
    end
    @twin_manager.update_twin(twin)
  end

  def init_method(name)
    method = DirectMethod.new
    method.method_name = name
    method.connect_timeout = @options.connect_timeout
    method.response_timeout = @options.response_timeout
    method
  end

  private :init_method
end