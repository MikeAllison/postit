module Slugable

  # Check to see if the object's slug has changed
  def slug_unchanged?(str)
    self.slug == str
  end

  # Check database to see if the slug doesn't already exist
  def slug_unique?(str)
    self.class.find_by(slug: str).nil?
  end

  def to_slug(str)
    slug = str = str.squish.gsub(/[^A-Za-z0-9]/, '-').gsub(/-+/, '-').downcase

    count = 2
    loop do
      break if slug_unchanged?(slug) || slug_unique?(slug)
      slug = str + "-#{count}"
      count += 1
    end

    self.slug = slug
  end

end
