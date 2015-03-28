class Post < ActiveRecord::Base
  require 'uri'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates_presence_of :title, message: "Title field can't be blank"
  validates_length_of :title, minimum: 5, message: "Title is too short (minimum is 5 characters)"
  validates_presence_of :url, message: "URL field can't be blank"
  validates_uniqueness_of :url, case_sensitive: false, message: "This URL has already been posted"
  validates_format_of :url, with: /https?:\/\/[\S]+/, message: "URL field must be a valid URL (ex. http://www.example.com)"
  validates_format_of :url, without: /\s\b/, message: "URL field cannot contain spaces"
  #validates_format_of :url, with: /#{URI::regexp(['http', 'https'])}/, message: 'URL field must be a valid URL (ex. http://www.example.com)'
  validates_presence_of :description, message: "Description field can't be blank"
end
