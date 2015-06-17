module Slugable
  extend ActiveSupport::Concern

  module ClassMethods
    def slugable_attribute(attr_name)
      self.slugged_attribute = attr_name
    end
  end

  included do
    class_attribute :slugged_attribute
    before_save :to_slug
  end

  def to_param
    self.slug
  end

  private

    # Check to see if the object's slug has changed
    def slug_unchanged?(slug)
      self.slug == slug
    end

    # Check database to see if the slug doesn't already exist
    def slug_unique?(slug)
      self.class.find_by(slug: slug).nil?
    end

    def to_slug
      slug = temp_slug = self.send(self.class.slugged_attribute).squish.gsub(/[^A-Za-z0-9]/, '-').gsub(/-+/, '-').downcase

      count = 2
      loop do
        break if slug_unchanged?(slug) || slug_unique?(slug)
        slug = temp_slug + "-#{count}"
        count += 1
      end

      self.slug = slug
    end

end
