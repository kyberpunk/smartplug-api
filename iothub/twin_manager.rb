require 'api_client'
require 'iothub_helper'
require 'json'

# Class provides methods for device twins management including direct methods
# invocation.
# For more information read: https://docs.microsoft.com/en-us/rest/api/iothub/devicetwinapi
class TwinManager
  API_VERSION = '2016-11-14'.freeze

  # Set twin manager options
  def initialize(options)
    @options = options
    @api_version_param = { :'api-version' => API_VERSION }
  end

  # Get device twin
  def get_twin(device_id)
    client = IotHubApiClient.new(@options)
    res = client.get(twins_path(device_id), @api_version_param)
    Twin.create(response_json(res))
  end

  # Update twin properties
  def update_twin(twin)
    update_twin_properties(twin.device_id, twin.properties.desired)
  end

  # Update twin properties
  def update_twin_properties(device_id, desired_properties)
    client = IotHubApiClient.new(@options)
    properties = { properties: { desired: desired_properties } }
    res = client.patch(twins_path(device_id), @api_version_param,
                       JSON.dump(properties))
    Twin.create(response_json(res))
  end

  # Query device twins
  def query_twins(query)
    client = IotHubApiClient.new(@options)
    res = client.post('/devices/query', @api_version_param,
                      JSON.dump(query: query))
    response_json(res).map do |twin|
      Twin.create(twin)
    end
  end

  # Invoke direct method on the device
  def invoke_method(device_id, direct_method)
    client = IotHubApiClient.new(@options)
    res = client.post("#{twins_path(device_id)}/methods", @api_version_param,
                      JSON.dump(direct_method.as_json))
    result = response_json(res)
    raise RefusedByDeviceError, 'Direct method refused by device' unless
        result[:status] == 200
    result[:payload]
  end

  def twins_path(device_id = nil)
    path = device_id ? "/#{device_id}" : ''
    "/twins#{path}"
  end

  def response_json(response)
    check_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def check_response(response)
    case response
      when Net::HTTPSuccess then
        nil
      when Net::HTTPUnauthorized then
        raise UnauthorizedError, 'Authentication failed'
      when Net::HTTPNotFound then
        raise DeviceNotFoundError, 'Resource not found'
      when Net::HTTPGatewayTimeOut then
        raise DeviceTimeoutError, 'Device timed out'
      else
        raise IotHubError, 'Unexpected response'
    end
  end

  private :twins_path, :response_json, :check_response
end