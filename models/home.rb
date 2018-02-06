class Home < ActiveRecord::Base
  has_many :appliances
  has_many :outlets
  belongs_to :user
end