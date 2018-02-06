class SmartplugApi < Sinatra::Application
  get '/smartplugs/:id' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    smartplug_manager = create_smartplug_manager
    MultiJson.dump(smartplug_manager.get_smartplug(outlet[:device_id]))
  end

  post '/smartplugs/:id/switch' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    smartplug_manager = create_smartplug_manager
    smartplug_manager.switch(outlet[:device_id], params[:value] == 'true')
    status 204
  end

  get '/smartplugs/:id/directdata' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    power_monitor = create_power_monitor
    MultiJson.dump(power_monitor.get_direct_data(outlet[:device_id]))
  end

  post '/smartplugs/:id/directdata/start' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    power_monitor = create_power_monitor
    power_monitor.start_direct_data(outlet[:device_id])
    status 204
  end
end