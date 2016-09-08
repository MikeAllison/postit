class Category < ActiveRecord::Base
  include Slugable # In 'models/concerns'

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates_presence_of :name, message: 'Name cannot be blank'
  validates_uniqueness_of :name, case_sensitive: false, message: 'This category already exists'
  validates_length_of :name, maximum: 14, message: 'Category name must be less than 15 characters'

  after_initialize :initialize_hidden, if: :new_record?
  after_initialize :initialize_posts_count, if: :new_record?

  set_slugable_attribute :name # Slugable

  default_scope { where(hidden: false) }
  default_scope { order(name: :asc) }

  def hide!
    self.hidden = true
    self.save
  end

  def unhide!
    self.hidden = false
    self.save
  end

  def increase_unhidden_posts_count
    self.unhidden_posts_count += 1
    self.save
  end

  def reduce_unhidden_posts_count
    self.unhidden_posts_count -= 1
    self.save
  end

  private

  def initialize_hidden
    self.hidden = false
  end

  def initialize_posts_count
    self.unhidden_posts_count = 0
  end
end
