class SmartplugApi < Sinatra::Application
  get '/appliances' do
    protected!
    appliances = DatabaseHelper.appliances_by_user_id(@user_id)
    MultiJson.dump(appliances)
  end

  get '/appliances/:id' do
    protected!
    appliance = DatabaseHelper.appliance_by_user_id(params[:id], @user_id)
    appliance ? MultiJson.dump(appliance) : not_found
  end

  get '/appliances/:id/outlet' do
    protected!
    appliance = DatabaseHelper.appliance_by_user_id(params[:id], @user_id)
    not_found unless appliance
    MultiJson.dump(appliance.outlet)
  end

  post '/appliances' do
    protected!
    new_appliance = MultiJson.load(request.body.read)
    home = Home.find_by(id: new_appliance[:home_id], user_id: @user_id)
    not_found unless home
    appliance = Home.new(new_appliance)
    save_record(appliance)
  end

  put '/appliances/:id' do
    protected!
    appliance = DatabaseHelper.appliance_by_user_id(params[:id], @user_id)
    not_found unless appliance
    updated_appliance = MultiJson.load(request.body.read)
    appliance.update(name: updated_appliance[:name],
                     appliance_type: updated_appliance[:appliance_type])
    save_record(appliance)
  end

  delete '/appliances/:id' do
    protected!
    appliance = DatabaseHelper.appliance_by_user_id(params[:id], @user_id)
    not_found unless appliance
    appliance.destroy
    status 204
  end
end