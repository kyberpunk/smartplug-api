class SmartplugApi < Sinatra::Application
  # Get smartplug resource
  get '/smartplugs/:id' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    smartplug_manager = create_smartplug_manager
    json(smartplug_manager.get_smartplug(outlet[:device_id]))
  end

  # Switch the smartplug relay
  post '/smartplugs/:id/switch' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    smartplug_manager = create_smartplug_manager
    smartplug_manager.switch(outlet[:device_id], params[:value] == 'true')
    status 204
  end

  # Get smartplug direct data
  get '/smartplugs/:id/directdata' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    power_monitor = create_power_monitor
    json(power_monitor.get_direct_data(outlet[:device_id]))
  end

  # Force smartplug to start sending the direct data
  post '/smartplugs/:id/directdata/start' do
    protected!
    outlet = DatabaseHelper.outlet_by_user_id(params[:id], @user_id)
    not_found unless outlet
    power_monitor = create_power_monitor
    power_monitor.start_direct_data(outlet[:device_id])
    status 204
  end
end