module Slugable

  def to_slug(str)
    slug = str = str.squish.gsub(/[^A-Za-z0-9]/, '-').gsub(/-+/, '-').downcase

    count = 2
    loop do
      break if slug_same?(slug) || slug_unique?(slug)
      slug = str + "-#{count}"
      count += 1
    end

    self.slug = slug
  end

  def slug_same?(str)
    self.slug == str
  end

  def slug_unique?(str)
    self.class.find_by(slug: str).nil?
  end

end
