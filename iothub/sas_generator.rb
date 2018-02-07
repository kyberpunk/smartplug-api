require 'open-uri'
require 'openssl'
require 'base64'
require 'cgi/util'

# Shared Access Signature generator for Azure services authentication
# More information on: https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-security
class SASGenerator
  def initialize(options)
    @options = options
  end

  # Generate authorization token
  def generate_token(expiry, uri_path)
    timestamp = Time.now.getutc.to_i + expiry
    uri = CGI.escape(uri_path)
    signature = CGI.escape(generate_signature(timestamp, uri_path))
    "SharedAccessSignature sr=#{uri}&sig=#{signature}&se=#{timestamp}&skn=#{@options.key_name}"
  end

  # Generate SAS signature
  def generate_signature(timestamp, uri_path)
    uri = CGI.escape(uri_path)
    content = "#{uri}\n#{timestamp}"
    secret = Base64.decode64(@options.key)
    hash = OpenSSL::HMAC.digest('sha256', secret, content)
    Base64.strict_encode64(hash)
  end
end