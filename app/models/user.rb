class User < ActiveRecord::Base
  include Slugable # In 'models/concerns'

  has_secure_password validations: false

  enum role: [:user, :moderator, :admin]

  has_many :posts
  has_many :comments
  has_many :votes
  has_many :flags

  validates_presence_of :username, message: 'Please enter a username'
  validates_format_of :username, without: /\s\b/, message: 'Username cannot contain spaces'
  validates_format_of :username, without: /\A[^a-zA-Z0-9]/, message: 'Username must start with a letter or number'
  validates_format_of :username, without: /[^a-zA-Z0-9-]/, message: 'Username may only contain: letters, numbers, and dashes'
  validates_format_of :username, without: /[^a-zA-Z0-9]\z/, message: 'Username must end with a letter or number'
  validates_length_of :username, maximum: 20, message: 'Username must be less than 20 characters'
  validates_uniqueness_of :username, case_sensitive: false, message: 'This username is not available'
  validates_presence_of :password, message: "Password can't be blank", on: :create
  validates_confirmation_of :password, message: "The passwords don't match", unless: Proc.new { |form| form.password.blank? }
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map.keys, message: 'The time zone is not valid'

  after_initialize :set_default_role, if: :new_record?
  before_validation :strip_username_whitespace

  set_slugable_attribute :username # Slugable

  def username_role
    self.user? ? "#{username}" : "#{username} [#{role}]"
  end

  private

  def set_default_role
    self.role ||= :user
  end

  def strip_username_whitespace
    self.username.strip!
  end
end
