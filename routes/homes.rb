class SmartplugApi < Sinatra::Application
  # Get home resources related to the currently signed user
  get '/homes' do
    protected!
    homes = Home.where(user_id: @user_id)
    json(homes)
  end

  # Get home resource by id
  get '/homes/:id' do
    protected!
    home = Home.find_by(id: params[:id], user_id: @user_id)
    home ? json(home) : not_found
  end

  # Create new home resource
  post '/homes' do
    protected!
    new_home = from_json
    home = Home.new(new_home)
    home[:user_id] = @user_id
    save_record(home)
  end

  # Update home resource
  put '/homes/:id' do
    protected!
    home = Home.find_by(id: params[:id], user_id: @user_id)
    not_found unless home
    home[:user_id] = @user_id
    updated_home = from_json
    updated_home[:id] = params[:id]
    home.update(updated_home)
    save_record(home)
  end

  # Delete home resource
  delete '/homes/:id' do
    protected!
    home = Home.find_by(id: params[:id], user_id: @user_id)
    not_found unless home
    home.destroy
    status 204
  end

  # Get appliance resources related to the home
  get '/homes/:id/appliances' do
    protected!
    home = Home.find_by(id: params[:id], user_id: @user_id)
    not_found unless home
    appliances = DatabaseHelper.home_appliances_by_user_id(home[:id], @user_id)
    json(appliances)
  end

  # Get outlet resources related to the home
  get '/homes/:id/outlets' do
    protected!
    home = Home.find_by(id: params[:id], user_id: @user_id)
    not_found unless home
    outlets = DatabaseHelper.home_outlets_by_user_id(home[:id], @user_id)
    json(outlets)
  end
end