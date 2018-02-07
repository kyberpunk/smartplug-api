# Twin desired properties (updated by backend)
class DesiredProperties < Hash
  def version
    self[:'$version']
  end

  def metadata
    self[:'$metadata']
  end
end

# Twin reported properties (updated by device)
class ReportedProperties < Hash
  def version
    self[:'$version']
  end

  def metadata
    self[:'$metadata']
  end
end

# Twin properties
class Properties
  attr_accessor :desired
  attr_accessor :reported

  def self.create(hash)
    obj = Properties.new
    obj.desired = DesiredProperties.new
    obj.desired.merge! hash[:desired]
    obj.reported = ReportedProperties.new
    obj.reported.merge! hash[:reported]
    obj
  end

  def as_json
    { desired: desired, reported: reported }
  end
end

# Device twin data
class Twin
  attr_accessor :device_id
  attr_accessor :etag
  attr_accessor :version
  attr_accessor :tags
  attr_accessor :properties

  def self.create(hash)
    obj = Twin.new
    obj.device_id = hash[:deviceId]
    obj.etag = hash[:etag]
    obj.version = hash[:version].to_i
    obj.tags = hash[:tags]
    obj.properties = Properties.create(hash[:properties])
    obj
  end

  def as_json
    { deviceId: device_id, etag: etag, version: version, tags: tags,
      properties: properties.as_json }
  end
end