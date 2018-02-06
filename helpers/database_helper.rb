class DatabaseHelper
  def self.appliances_by_user_id(user_id)
    Appliance.joins(:home).where('homes.user_id' => user_id)
  end

  def self.appliance_by_user_id(id, user_id)
    Appliance.joins(:home).where('homes.user_id' => user_id,
                                  'appliances.id' => id).take!
  end

  def self.home_appliances_by_user_id(home_id, user_id)
    Appliance.joins(:home).where('homes.user_id' => user_id,
                                  'homes.id' => home_id)
  end

  def self.outlets_by_user_id(user_id)
    Outlet.joins(:home).where('homes.user_id' => user_id)
  end

  def self.outlet_by_user_id(id, user_id)
    Outlet.joins(:home).where('homes.user_id' => user_id,
                               'outlets.id' => id).take
  end

  def self.home_outlets_by_user_id(home_id, user_id)
    Outlet.joins(:home).where('homes.user_id' => user_id,
                               'homes.id' => home_id)
  end
end