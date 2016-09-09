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

  after_initialize :set_default_status, if: :new_record?
  after_initialize :set_default_role, if: :new_record?
  before_validation :strip_username_whitespace

  set_slugable_attribute :username # Slugable

  def self.search(search_term)
    return User.all if !search_term

    users = User.arel_table
    User.where(users[:username].matches("%#{search_term}%"))
  end

  def disable!
    self.disabled = true
    self.save
  end

  def enable!
    self.disabled = false
    self.save
  end

  def username_role
    self.user? ? "#{username}" : "#{username} [#{role}]"
  end

  def flagged_items_count
    posts = Post.where("user_id = ? AND total_flags > ?", self.id, 0).size
    comments = Comment.where("user_id = ? AND total_flags > ?", self.id, 0).size
    posts + comments
  end

  private

  def set_default_status
    self.disabled = false
  end

  def set_default_role
    self.role ||= :user
  end

  def strip_username_whitespace
    self.username.strip!
  end
end
