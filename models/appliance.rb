class Appliance < ActiveRecord::Base
  belongs_to :home
  has_one :outlet
end