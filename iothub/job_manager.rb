require 'api_client'
require 'iothub_helper'
require 'json'

# Class provides methods for Iot Hub jobs management.
# For more information see: https://docs.microsoft.com/en-us/rest/api/iothub/jobapi
class JobManager
  API_VERSION = '2016-11-14'.freeze

  # Set job manager options
  def initialize(options)
    @options = options
    @api_version_param = { :'api-version' => API_VERSION }
  end

  # Get information about job
  def get_job(job_id)
    client = IotHubApiClient.new(@options)
    res = client.get(jobs_path(job_id), @api_version_param)
    JobResponse.new(response_json(res))
  end

  # Create new job
  def create_job(job)
    client = IotHubApiClient.new(@options)
    res = client.put(jobs_path(job.job_id), @api_version_param,
                     JSON.dump(job.as_json))
    JobResponse.new(response_json(res))
  end

  # Cancel existing job
  def cancel_job(job_id)
    client = IotHubApiClient.new(@options)
    res = client.post("#{jobs_path(job_id)}/close", @api_version_param, nil)
    JobResponse.new(response_json(res))
  end

  # Query jobs
  def query_job(continuation_token = nil, status = nil, type = nil, page_size = nil)
    client = IotHubApiClient.new(@options)
    params = @api_version_param.clone
    params[:jobStatus] = status if status
    params[:jobType] = type if type
    params[:pageSize] = page_size if page_size
    params[:continuationToken] = continuation_token if continuation_token
    res = client.get("#{jobs_path}/query", params)
    QueryResultWithContinuation.create(response_json(res))
  end

  def jobs_path(job_id = nil)
    path = job_id ? "/#{job_id}" : ''
    "/jobs/v2#{path}"
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

  private :jobs_path, :response_json, :check_response
end