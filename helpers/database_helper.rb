# Helper contains useful methods for querying records
class DatabaseHelper
  # Get all appliances filtered by user
  def self.appliances_by_user_id(user_id)
    Appliance.joins(:home).where('homes.user_id' => user_id)
  end

  # Get appliance by id filtered by user
  def self.appliance_by_user_id(id, user_id)
    Appliance.joins(:home).where('homes.user_id' => user_id,
                                 'appliances.id' => id).take!
  end

  # Get appliances related to the home filtered by user
  def self.home_appliances_by_user_id(home_id, user_id)
    Appliance.joins(:home).where('homes.user_id' => user_id,
                                 'homes.id' => home_id)
  end

  # Get all outlets filtered by user
  def self.outlets_by_user_id(user_id)
    Outlet.joins(:home).where('homes.user_id' => user_id)
  end

  # Get outlet by id filtered by user
  def self.outlet_by_user_id(id, user_id)
    Outlet.joins(:home).where('homes.user_id' => user_id,
                              'outlets.id' => id).take
  end

  # Get appliances related to the home filtered by user
  def self.home_outlets_by_user_id(home_id, user_id)
    Outlet.joins(:home).where('homes.user_id' => user_id,
                              'homes.id' => home_id)
  end
end