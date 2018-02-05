class DirectData
  attr_accessor :timestamp
  attr_accessor :period
  attr_accessor :active_power
  attr_accessor :rms_voltage
  attr_accessor :rms_current

  def self.create(twin)
    obj = DirectData.new
    obj.period = twin.properties.reported[:ddper]
    obj.timestamp = twin.properties.reported[:ddts]
    obj.active_power = twin.properties.reported[:ddrmsp]
    obj.rms_voltage = twin.properties.reported[:ddrmsv]
    obj.rms_current = twin.properties.reported[:ddrmsc]
    obj
  end
end