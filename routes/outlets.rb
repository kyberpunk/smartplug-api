class SmartplugApi < Sinatra::Application
  get '/outlets' do
    protected!
    outlets = DatabaseHelper.outlets_by_user_id(@user_id)
    json(outlets)
  end

  get '/outlets/:id' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    outlet ? json(outlet) : not_found
  end

  get '/outlets/:id/appliance' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    json(outlet.appliance)
  end

  post '/outlets' do
    protected!
    new_outlet = from_json
    home = Home.find_by(id: new_outlet[:home_id], user_id: @user_id)
    not_found unless home
    if new_outlet[:appliance_id]
      appliance = Appliance.find(new_outlet[:appliance_id])
      not_found if !appliance || appliance[:home_id] != home[:id]
    end
    if new_outlet[:device_id]
      smartplug_manager = create_smartplug_manager
      not_found unless smartplug_manager.get_smartplug(new_outlet[:device_id])
    end
    outlet = Outlet.new(new_outlet)
    save_record(outlet)
  end

  put '/outlets/:id' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    updated_outlet = from_json
    if updated_outlet[:appliance_id]
      appliance = Appliance.find(updated_outlet[:appliance_id])
      home = Home.find_by(id: outlet[:home_id], user_id: @user_id)
      not_found if !home || !appliance || appliance[:home_id] != home[:id]
    end
    outlet.update(appliance_id: updated_outlet[:appliance_id],
                  name: updated_outlet[:name])
    save_record(outlet)
  end

  delete '/outlets/:id' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    outlet.destroy
    status 204
  end
end