# Iot Hub devices registry statistics
class RegistryStatistics
  attr_accessor :total_device_count
  attr_accessor :enabled_device_count
  attr_accessor :disabled_device_count

  def self.create(hash)
    obj = RegistryStatistics.new
    obj.total_device_count = hash[:totalDeviceCount].to_i
    obj.enabled_device_count = hash[:enabledDeviceCount].to_i
    obj.disabled_device_count = hash[:disabledDeviceCount].to_i
    obj
  end

  def as_json
    { totalDeviceCount: total_device_count,
      enabledDeviceCount: enabled_device_count,
      disabledDeviceCount: disabled_device_count }
  end
end