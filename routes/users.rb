class SmartplugApi < Sinatra::Application
  # Get currently signed user resource
  get '/users/self' do
    protected!
    user = User.find(@user_id)
    not_found unless user
    json(id: user[:id], user_name: user[:user_name],
         email: user[:email])
  end

  # Register new user
  post '/users' do
    new_user = from_json
    user = User.new(user_name: new_user[:user_name], email: new_user[:email])
    pwd_user = PasswordUser.new(user)
    pwd_user.password = new_user[:password]
    if user.save
      status 201
      json(id: user[:id], user_name: user[:user_name],
           email: user[:email])
    else
      status 400
      json(user.errors.messages)
    end
  end

  # Update currently signed user resource
  patch '/users/self' do
    protected!
    updated_user = from_json
    user = User.find(@user_id)
    pwd_user = PasswordUser.new(user)
    user[:user_name] = updated_user[:user_name] if updated_user[:user_name]
    user[:email] = updated_user[:email] if updated_user[:email]
    pwd_user.password = updated_user[:password] if updated_user[:password]
    if user.save
      status 201
      json(id: user[:id], user_name: user[:user_name],
           email: user[:email])
    else
      status 400
      json(user.errors.messages)
    end
  end

  # Delete currently signed user resource
  delete '/users/self' do
    protected!
    user = User.find(@user_id)
    not_found unless user
    user.destroy
    status 204
  end

  # Login and return JWT authorization token
  post '/users/login' do
    credentials = from_json
    user = User.find_by(user_name: credentials[:user_name])
    halt 401 unless user
    pwd_user = PasswordUser.new(user)
    if pwd_user.password == credentials[:password]
      headers = {
        exp: Time.now.to_i + 86_400
      }
      @token = JWT.encode({ user_id: user[:id] }, settings.signing_key, 'RS256',
                          headers)
      status 200
      json(token: @token, expiration: Time.new(headers[:exp]))
    else
      status 401
    end
  end

  # Logout user
  post '/users/logout' do
    protected!
  end
end