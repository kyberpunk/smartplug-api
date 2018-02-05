require 'net/http'
require 'sas_generator'

class HTTPError < StandardError
  def initialize(msg, code)
    @code = code
    super(msg)
  end

  attr_reader :code
end

class IotHubApiClient
  def initialize(options)
    @options = options
    @host = @options.host
    @generator = SASGenerator.new(options)
  end

  def get(uri_string, parameters, if_match = nil)
    call_api(Net::HTTP::Get, uri_string, parameters, nil, if_match)
  end

  def post(uri_string, parameters, content, if_match = nil)
    call_api(Net::HTTP::Post, uri_string, parameters, content, if_match)
  end

  def put(uri_string, parameters, content, if_match = nil)
    call_api(Net::HTTP::Put, uri_string, parameters, content, if_match)
  end

  def patch(uri_string, parameters, content, if_match = nil)
    call_api(Net::HTTP::Patch, uri_string, parameters, content, if_match)
  end

  def delete(uri_string, parameters, if_match = nil)
    call_api(Net::HTTP::Delete, uri_string, parameters, nil, if_match)
  end

  def create_uri(uri_string, parameters)
    uri = URI("https://#{@host}#{uri_string}")
    uri.query = URI.encode_www_form(parameters)
    uri
  end

  def call_api(method, uri_string, parameters, content, if_match)
    uri = create_uri(uri_string, parameters)
    req = method.new(uri)
    req['If-Match'] = if_match if if_match
    req['Authorization'] = @generator.generate_token(@options.expiry, @host)
    req.body = content if content
    req.content_type = 'application/json' if content
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end

  private :create_uri, :call_api
end