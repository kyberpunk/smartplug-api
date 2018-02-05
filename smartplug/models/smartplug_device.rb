class SmartplugDevice
  attr_accessor :device_id
  attr_accessor :actual_firmware_version
  attr_accessor :firmware_status
  attr_accessor :firmware_status_updated_time
  attr_accessor :local_network_ssid
  attr_accessor :local_network_ip
  attr_accessor :is_switched_on
  attr_accessor :is_switched_on_updated_time
  attr_accessor :connection_state
  attr_accessor :connection_state_updated_time

  def self.create(device, twin)
    obj = SmartplugDevice.new
    obj.device_id = device.device_id
    obj.actual_firmware_version = twin.properties.reported[:actualFirmwareVersion]
    obj.firmware_status = twin.properties.reported[:firmwareStatus]
    obj.firmware_status_updated_time = Time.iso8601(twin.properties.reported.metadata[:firmwareStatus][:'$lastUpdated'])
    obj.local_network_ssid = twin.properties.reported[:localNetworkSsid]
    obj.local_network_ip = twin.properties.reported[:localNetworkIp]
    obj.is_switched_on = twin.properties.reported[:isSwitchedOn]
    obj.is_switched_on_updated_time = Time.iso8601(twin.properties.reported.metadata[:isSwitchedOn][:'$lastUpdated'])
    obj.connection_state = device.connection_state
    obj.connection_state_updated_time = device.connection_state_updated_time
    obj
  end
end