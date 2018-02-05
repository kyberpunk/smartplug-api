require 'api_client'
require 'iothub_helper'
require 'json'

class DeviceManager
  API_VERSION = '2016-11-14'.freeze

  def initialize(options)
    @options = options
    @api_version_param = { :'api-version' => API_VERSION }
  end

  def get_devices(top = nil)
    client = IotHubApiClient.new(@options)
    params = @api_version_param.clone
    params[:top] = top if top
    res = client.get(devices_path, params)
    response_json(res).map do |data|
      Device.create(data)
    end
  end

  def get_device(device_id)
    client = IotHubApiClient.new(@options)
    res = client.get(devices_path(device_id), @api_version_param)
    Device.create(response_json(res))
  end

  def create_device(device)
    client = IotHubApiClient.new(@options)
    res = client.post(devices_path(device_id),
                      @api_version_param, JSON.dump(device))
    Device.create(response_json(res))
  end

  def update_device(device)
    client = IotHubApiClient.new(@options)
    json = JSON.dump(device.as_json)
    res = client.put(devices_path(device.device_id),
                     @api_version_param, JSON.dump(device.as_json), '*')
    Device.create(response_json(res))
  end

  def delete_device(device_id)
    client = IotHubApiClient.new(@options)
    res = client.delete(devices_path(device_id), @api_version_param,
                        '*')
    check_response(res)
  end

  def bulk_update(devices)
    client = IotHubApiClient.new(@options)
    hash = devices.map &:as_json
    res = client.post(devices_path, @api_version_param, JSON.dump(hash))
    check_response(res)
  end

  def registry_statistics
    client = IotHubApiClient.new(@options)
    res = client.get('/statistics/devices', @api_version_param)
    RegistryStatistics.create(response_json(res))
  end

  def service_statistics
    client = IotHubApiClient.new(@options)
    res = client.get('/statistics/service', @api_version_param)
    ServiceStatistics.create(response_json(res))
  end

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
