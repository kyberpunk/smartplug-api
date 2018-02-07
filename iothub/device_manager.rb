require 'api_client'
require 'iothub_helper'
require 'json'

# Device manager class is used for managing Iot Hub devices registry.
# For more information read: https://docs.microsoft.com/en-us/rest/api/iothub/deviceapi
class DeviceManager
  API_VERSION = '2016-11-14'.freeze

  # Set device manager options
  def initialize(options)
    @options = options
    @api_version_param = { :'api-version' => API_VERSION }
  end

  # Get all devices or specific top number of devices
  def get_devices(top = nil)
    client = IotHubApiClient.new(@options)
    params = @api_version_param.clone
    params[:top] = top if top
    res = client.get(devices_path, params)
    response_json(res).map do |data|
      Device.create(data)
    end
  end

  # Get specific device info
  def get_device(device_id)
    client = IotHubApiClient.new(@options)
    res = client.get(devices_path(device_id), @api_version_param)
    Device.create(response_json(res))
  end

  # Create new device identity
  def create_device(device)
    client = IotHubApiClient.new(@options)
    res = client.post(devices_path(device_id),
                      @api_version_param, JSON.dump(device))
    Device.create(response_json(res))
  end

  # Update device info
  def update_device(device)
    client = IotHubApiClient.new(@options)
    json = JSON.dump(device.as_json)
    res = client.put(devices_path(device.device_id),
                     @api_version_param, JSON.dump(device.as_json), '*')
    Device.create(response_json(res))
  end

  # Delete device identity
  def delete_device(device_id)
    client = IotHubApiClient.new(@options)
    res = client.delete(devices_path(device_id), @api_version_param,
                        '*')
    check_response(res)
  end

  # Perform bulk update on devices
  def bulk_update(devices)
    client = IotHubApiClient.new(@options)
    hash = devices.map &:as_json
    res = client.post(devices_path, @api_version_param, JSON.dump(hash))
    check_response(res)
  end

  # Get device registry statistics
  def registry_statistics
    client = IotHubApiClient.new(@options)
    res = client.get('/statistics/devices', @api_version_param)
    RegistryStatistics.create(response_json(res))
  end

  # Get Iot Hub service statistics
  def service_statistics
    client = IotHubApiClient.new(@options)
    res = client.get('/statistics/service', @api_version_param)
    ServiceStatistics.create(response_json(res))
  end

  # Purge all commands waiting in the queue
  def purge_command_queue(device_id)
    client = IotHubApiClient.new(@options)
    res = client.delete("#{devices_path(device_id)}/commands",
                        @api_version_param)
    PurgeCommandQueueResult.create(response_json(res))
  end

  def devices_path(device_id = nil)
    path = device_id ? "/#{device_id}" : ''
    "/devices#{path}"
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
      else
        raise IotHubError, 'Unexpected response'
    end
  end

  private :devices_path, :response_json, :check_response
end
