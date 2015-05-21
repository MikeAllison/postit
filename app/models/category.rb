class Category < ActiveRecord::Base

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates_presence_of :name, message: "Name cannot be blank"
  validates_uniqueness_of :name, case_sensitive: false, message: "This category already exists"
  validates_length_of :name, maximum: 14, message: "Category name must be less than 15 characters"

  before_save :save_slug

  default_scope { order(name: :asc) }

  def to_param
    self.slug
  end

  private

    def save_slug
      self.slug = self.name.squish.gsub(/\s*[^A-Za-z0-9]\s*/, '-').gsub(/-+/, '-').downcase
    end

end
