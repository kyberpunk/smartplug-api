class Outlet < ActiveRecord::Base
  belongs_to :home
  belongs_to :appliance

  validates :device_id, uniqueness: true
end