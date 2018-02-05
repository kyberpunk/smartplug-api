class X509Thumbprint
  attr_accessor :primary_thumbprint
  attr_accessor :secondary_thumbprint

  def self.create(hash)
    obj = X509Thumbprint.new
    obj.primary_thumbprint = hash[:primaryThumbprint]
    obj.secondary_thumbprint = hash[:secondaryThumbprint]
    obj
  end

  def as_json
    { primaryThumbprint: primary_thumbprint,
      secondaryThumbprint: secondary_thumbprint }
  end
end

class SymmetricKey
  attr_accessor :primary_key
  attr_accessor :secondary_key

  def self.create(hash)
    obj = SymmetricKey.new
    obj.primary_key = hash[:primaryKey]
    obj.secondary_key = hash[:secondaryKey]
    obj
  end

  def as_json
    { primaryKey: primary_key, secondaryKey: secondary_key }
  end
end

class Authentication
  attr_accessor :symmetric_key
  attr_accessor :x509_thumbprint

  def self.create(hash)
    obj = Authentication.new
    obj.symmetric_key = SymmetricKey.create(hash[:symmetricKey])
    obj.x509_thumbprint = X509Thumbprint.create(hash[:x509Thumbprint])
    obj
  end

  def as_json
    { symmetricKey: symmetric_key.as_json,
      x509Thumbprint: x509_thumbprint.as_json }
  end
end

class Device
  attr_accessor :device_id
  attr_accessor :generation_id
  attr_accessor :etag
  attr_accessor :status
  attr_accessor :status_reason
  attr_accessor :connection_state
  attr_accessor :connection_state_updated_time
  attr_accessor :status_updated_time
  attr_accessor :last_activity_time
  attr_accessor :cloud_to_device_message_count
  attr_accessor :authentication

  def self.create(hash)
    obj = Device.new
    obj.device_id = hash[:deviceId]
    obj.generation_id = hash[:generationId]
    obj.etag = hash[:etag]
    obj.status = hash[:status]
    obj.status_reason = hash[:statusReason]
    obj.connection_state = hash[:connectionState].to_sym
    obj.connection_state_updated_time = Time.iso8601(hash[:connectionStateUpdatedTime])
    obj.status_updated_time = Time.iso8601(hash[:statusUpdatedTime])
    obj.last_activity_time = Time.iso8601(hash[:lastActivityTime])
    obj.cloud_to_device_message_count = hash[:cloudToDeviceMessageCount].to_i
    obj.authentication = Authentication.create(hash[:authentication])
    obj
  end

  def as_json
    { deviceId: device_id, generationId: generation_id, etag: etag,
      connectionState: connection_state,
      status: status, statusReason: status_reason,
      connectionStateUpdatedTime: connection_state_updated_time.iso8601,
      statusUpdatedTime: status_updated_time.iso8601,
      lastActivityTime: last_activity_time.iso8601,
      cloudToDeviceMessageCount: cloud_to_device_message_count,
      authentication: authentication.as_json }
  end
end