class SmartplugApi < Sinatra::Application
  get '/users/self' do
    protected!
    user = User.find(@user_id)
    not_found unless user
    MultiJson.dump(id: user[:id], user_name: user[:user_name],
                   email: user[:email])
  end

  post '/users' do
    new_user = MultiJson.load(request.body.read, symbolize_keys: true)
    user = User.new(user_name: new_user[:user_name], email: new_user[:email])
    pwd_user = PasswordUser.new(user)
    pwd_user.password = new_user[:password]
    if user.save
      status 201
      MultiJson.dump(id: user[:id], user_name: user[:user_name],
                     email: user[:email])
    else
      status 400
      MultiJson.dump(user.errors.messages)
    end
  end

  patch '/users/self' do
    protected!
    updated_user = MultiJson.load(request.body.read, symbolize_keys: true)
    user = User.find(@user_id)
    pwd_user = PasswordUser.new(user)
    user[:user_name] = updated_user[:user_name] if updated_user[:user_name]
    user[:email] = updated_user[:email] if updated_user[:email]
    pwd_user.password = updated_user[:password] if updated_user[:password]
    if user.save
      status 201
      MultiJson.dump(id: user[:id], user_name: user[:user_name],
                     email: user[:email])
    else
      status 400
      MultiJson.dump(user.errors.messages)
    end
  end

  delete '/users/self' do
    protected!
    user = User.find(@user_id)
    not_found unless user
    user.destroy
    status 204
  end

  post '/users/login' do
    credentials = MultiJson.load(request.body.read, symbolize_keys: true)
    user = User.find_by(user_name: credentials[:user_name])
    halt 401 unless user
    pwd_user = PasswordUser.new(user)
    if pwd_user.password == credentials[:password]
      headers = {
        exp: Time.now.to_i + 86_400
      }
      @token = JWT.encode({ user_id: user[:id] }, settings.signing_key, 'RS256', headers)
      status 200
      MultiJson.dump(jwt_token: @token, expiration: headers[:exp])
    else
      status 401
    end
  end

  post '/users/logout' do
    protected!
  end
end