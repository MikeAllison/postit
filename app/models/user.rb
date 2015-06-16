class User < ActiveRecord::Base

  include Slugable # In 'models/concerns'

  has_secure_password validations: false

  enum role: [:user, :moderator, :admin]

  has_many :posts
  has_many :comments
  has_many :votes

  validates_presence_of :username, message: "Please enter a username"
  #validates_format_of :username, without: /\s\b/, message: "Username cannot contain spaces"
  validates_uniqueness_of :username, case_sensitive: false, message: "This username has already been taken"
  #validates_presence_of :password, message: "Password can't be blank"
  #validates_confirmation_of :password, message: "The passwords don't match"
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map.keys, message: "The time zone is not valid"

  after_initialize :set_default_role, if: :new_record?
  before_validation :strip_username_whitespace

  slugable_attribute :username # Slugable

  def username_role
    self.user? ? "#{username}" : "#{username} [#{role}]"
  end

  protected

    def set_default_role
      self.role ||= :user
    end

    def strip_username_whitespace
      self.username.strip!
    end

end
