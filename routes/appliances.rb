class SmartplugApi < Sinatra::Application
  # Get appliance resources
  get '/appliances' do
    protected!
    appliances = DatabaseHelper.appliances_by_user_id(@user_id)
    json(appliances)
  end

  # Get appliance by id
  get '/appliances/:id' do
    protected!
    appliance = DatabaseHelper.appliance_by_user_id(params[:id], @user_id)
    appliance ? json(appliance) : not_found
  end

  # Get outlet resource assigned to the appliance if any
  get '/appliances/:id/outlet' do
    protected!
    appliance = DatabaseHelper.appliance_by_user_id(params[:id], @user_id)
    not_found unless appliance
    json(appliance.outlet)
  end

  # Create new appliance resource
  post '/appliances' do
    protected!
    new_appliance = from_json
    home = Home.find_by(id: new_appliance[:home_id], user_id: @user_id)
    not_found unless home
    appliance = Appliance.new(new_appliance)
    save_record(appliance)
  end

  # Update appliance resource
  put '/appliances/:id' do
    protected!
    appliance = DatabaseHelper.appliance_by_user_id(params[:id], @user_id)
    not_found unless appliance
    updated_appliance = from_json
    appliance.update(name: updated_appliance[:name],
                     appliance_type: updated_appliance[:appliance_type])
    save_record(appliance)
  end

  # Delete appliance resource
  delete '/appliances/:id' do
    protected!
    appliance = DatabaseHelper.appliance_by_user_id(params[:id], @user_id)
    not_found unless appliance
    appliance.destroy
    status 204
  end
end