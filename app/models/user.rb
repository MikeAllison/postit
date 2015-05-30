class User < ActiveRecord::Base

  include Slugable # In 'lib/modules'

  has_secure_password validations: false

  has_many :posts
  has_many :comments
  has_many :votes

  validates_presence_of :username, message: "Please enter a username"
  #validates_format_of :username, without: /\s\b/, message: "Username cannot contain spaces"
  validates_uniqueness_of :username, case_sensitive: false, message: "This username has already been taken"
  validates_presence_of :password, message: "Password can't be blank"
  validates_confirmation_of :password, message: "The passwords don't match"

  before_validation :strip_username_whitespace
  before_save :create_slug

  def to_param
    self.slug
  end

  private

    def strip_username_whitespace
      self.username.strip!
    end

    def create_slug
      # Usernames are unique so this doesn't need to verify uniqueness
      to_slug(self.username)
    end

end
