require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/namespace'
require 'sinatra/json'
require './config/environments'
require './models/home'

mime_type :json, 'application/json'


get '/' do
  'Hello world'
end

namespace '/api/v2' do
  before do
    content_type :json
  end

  after do
    response unless [Hash, Array].include?(response.body.class)
    content_type('application/json', charset: 'utf-8')
    response.body = MultiJson.dump(response.body)
    response
  end

  post '/homes' do
    new_home = MultiJson.parse(request.body.read)
    @home = Home.new(new_home)
    if @home.save
      @home
    else
      @home.errors.messages
    end
  end
end