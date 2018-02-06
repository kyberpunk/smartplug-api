require 'bcrypt'

class User < ActiveRecord::Base
  has_many :homes
  validates :user_name, uniqueness: true
end

class PasswordUser
  include BCrypt

  def initialize(user)
    @user = user
  end

  def password
    @password ||= BCrypt::Password.new(@user[:password_hash])
  end

  def password=(password)
    @user[:password_hash] = BCrypt::Password.create(password)
  end
end