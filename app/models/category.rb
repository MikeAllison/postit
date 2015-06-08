class Category < ActiveRecord::Base

  include Slugable # In 'models/concerns'

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates_presence_of :name, message: "Name cannot be blank"
  validates_uniqueness_of :name, case_sensitive: false, message: "This category already exists"
  validates_length_of :name, maximum: 14, message: "Category name must be less than 15 characters"

  slugable_attribute :name

  default_scope { order(name: :asc) }

end
