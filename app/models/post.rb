class Post < ActiveRecord::Base
  require 'uri'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: { minimum: 5 }
  validates :url, presence: true
  validates :url, uniqueness: { case_sensitive: false }
  validates_format_of :url, with: URI.regexp, message: ' must be a URL (ex. http://www.example.com)'
  validates :description, presence: true
end
