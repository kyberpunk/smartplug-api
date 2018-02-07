require 'bcrypt'

class User < ActiveRecord::Base
  has_many :homes
  validates :user_name, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
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