class Post < ActiveRecord::Base

  include Flagable # In 'models/concerns'
  include Slugable # In 'models/concerns'
  include Voteable # In 'models/concerns'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates_presence_of :title, message: "Title field can't be blank"
  validates_length_of :title, minimum: 2, message: "Title is too short (minimum is 2 characters)"
  validates_presence_of :url, message: "URL field can't be blank"
  validates_uniqueness_of :url, case_sensitive: false, message: "This URL has already been posted"
  validates_format_of :url, with: /https?:\/\/[\S]+/, message: "URL field must be a valid URL (ex. http://www.example.com)"
  validates_format_of :url, without: /\s\b/, message: "URL field cannot contain spaces"
  validates_presence_of :description, message: "Description field can't be blank"
  validates_presence_of :categories, message: "Please select at least one category"

  after_initialize :initialize_comments_count, if: :new_record?
  after_initialize :initialize_tallied_votes, if: :new_record? # Voteable
  before_validation :strip_url_whitespace
  before_validation :downcase_url

  slugable_attribute :title # Slugable

  protected

    def strip_url_whitespace
      self.url.gsub!(/\s+/,'')
    end

    def downcase_url
      self.url.downcase!
    end

  private

    def initialize_comments_count
      self.comments_count = 0
    end

end
