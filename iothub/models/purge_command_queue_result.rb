# Purge command queue representation
class PurgeCommandQueueResult
  attr_accessor :total_messages_purged
  attr_accessor :device_id

  def self.create(hash)
    obj = PurgeCommandQueueResult.new
    obj.total_messages_purged = hash[:totalMessagesPurged].to_i
    obj.device_id = hash[:deviceId]
    obj
  end

  def as_json
    { totalMessagesPurged: total_messages_purged, deviceId: device_id }
  end
end