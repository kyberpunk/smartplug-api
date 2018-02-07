# Iot Hub direct method data representation
class DirectMethod
  attr_accessor :method_name
  attr_accessor :payload
  attr_accessor :response_timeout
  attr_accessor :connect_timeout

  def self.create(hash)
    obj = DirectMethod.new
    obj.method_name = hash[:methodName]
    obj.payload = hash[:payload]
    obj.response_timeout = hash[:responseTimeoutInSeconds].to_i
    obj.connect_timeout = hash[:connectTimeoutInSeconds].to_i
    obj
  end

  def as_json
    { methodName: method_name, payload: payload,
      responseTimeoutInSeconds: response_timeout,
      connectTimeoutInSeconds: connect_timeout }
  end
end