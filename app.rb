require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require 'openssl'
require 'jwt'
require 'multi_json'
require './helpers/database_helper'
require './smartplug/smartplug'
require './models/home'
require './models/user'
require './models/appliance'
require './models/outlet'
require './iothub/client'
require './config/environments'

# JWT authentication based on example: https://github.com/nickdufresne/jwt-sinatra-example
signing_key_path = File.expand_path("../app.rsa", __FILE__)
verify_key_path = File.expand_path("../app.rsa.pub", __FILE__)

signing_key = ''
verify_key = ''

File.open(signing_key_path) do |file|
  signing_key = OpenSSL::PKey.read(file)
end

File.open(verify_key_path) do |file|
  verify_key = OpenSSL::PKey.read(file)
end

set :signing_key, signing_key
set :verify_key, verify_key

set :show_exceptions, false
set :raise_errors, false

MultiJson.use(:oj)

class SmartplugApi < Sinatra::Application
  helpers do
    def protected!
      return if authorized?
      @user_id = nil
      halt 401
    end

    def extract_token
      header = request.env['HTTP_AUTHORIZATION']
      return nil unless header
      match = header.match(/Bearer (.*)/)
      match.captures ? match.captures[0] : nil
    end

    def authorized?
      @token = extract_token
      begin
        payload, header = JWT.decode(@token, settings.verify_key, true, algorithm: 'RS256')

        @exp = header['exp']

        # check to see if the exp is set (we don't accept forever tokens)
        if @exp.nil?
          puts "Access token doesn't have exp set"
          return false
        end

        @exp = Time.at(@exp.to_i)

        # make sure the token hasn't expired
        if Time.now > @exp
          puts 'Access token expired'
          return false
        end

        @user_id = payload['user_id']

      rescue JWT::DecodeError => e
        return false
      end
    end

    def create_smartplug_manager
      twin_manager = TwinManager.new(settings.iothub_options)
      device_manager = DeviceManager.new(settings.iothub_options)
      SmartplugManager.new(settings.smartplug_options,
                           device_manager, twin_manager)
    end

    def create_power_monitor
      twin_manager = TwinManager.new(settings.iothub_options)
      device_manager = DeviceManager.new(settings.iothub_options)
      PowerMonitor.new(settings.smartplug_options, device_manager,
                       twin_manager)
    end
  end

  not_found do
    halt 404
  end

  def save_record(record)
    if record.save
      status 201
      json(record)
    else
      status 400
      json(record.errors.messages)
    end
  end

  def json(object)
    MultiJson.dump(object, pretty: true)
  end

  def from_json
    MultiJson.load(request.body.read, symbolize_keys: true)
  end

  error IotHubError, SmartplugError do
    status 400
    json(message: env['sinatra.error'].message)
  end

  get '/' do
    json('SMARTPLUG_API')
  end
end

require_relative 'routes/homes'
require_relative 'routes/appliances'
require_relative 'routes/outlets'
require_relative 'routes/smartplugs'
require_relative 'routes/users'