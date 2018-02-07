# Iot Hub service statistics
class ServiceStatistics
  attr_accessor :connected_device_count

  def self.create(hash)
    obj = ServiceStatistics.new
    obj.connected_device_count = hash[:connectedDeviceCount].to_i
    obj
  end

  def as_json
    { connectedDeviceCount: connected_device_count }
  end
end