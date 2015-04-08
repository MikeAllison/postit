class User < ActiveRecord::Base
  has_secure_password(validations: false)

  has_many :posts
  has_many :comments

  validates_presence_of :username, message: "Please enter a username"
  validates_uniqueness_of :username, case_sensitive: false, message: "This username has already been taken"
  validates_presence_of :password, message: "Password can't be blank"
  validates_confirmation_of :password, message: "The passwords don't match"
end
