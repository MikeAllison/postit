class Post < ActiveRecord::Base
  #require 'uri'

  before_validation :strip_url_whitespace
  before_validation :downcase_url

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates_presence_of :title, message: "Title field can't be blank"
  validates_length_of :title, minimum: 5, message: "Title is too short (minimum is 5 characters)"
  validates_presence_of :url, message: "URL field can't be blank"
  validates_uniqueness_of :url, case_sensitive: false, message: "This URL has already been posted"
  validates_format_of :url, with: /https?:\/\/[\S]+/, message: "URL field must be a valid URL (ex. http://www.example.com)"
  validates_format_of :url, without: /\s\b/, message: "URL field cannot contain spaces"
  #validates_format_of :url, with: /#{URI::regexp(['http', 'https'])}/, message: 'URL field must be a valid URL (ex. http://www.example.com)'
  validates_presence_of :description, message: "Description field can't be blank"
  validates_presence_of :categories, message: "Please select at least one category"

  def total_votes
    total_votes = 0
    upvotes = self.votes.where("vote = ?", true).count
    downvotes = self.votes.where("vote = ?", false).count

    total_votes = upvotes - downvotes
  end

  def has_same_vote_from?(user, vote)
    return true if self.votes.where("user_id = ? and vote = ?", user, vote).exists?
  end

  def has_opposite_vote_from?(user, vote)
    return true if self.votes.where("user_id = ? and vote != ?", user, vote).exists?
  end

  private
    def strip_url_whitespace
      self.url.strip!
    end

    def downcase_url
      self.url.downcase!
    end
end
