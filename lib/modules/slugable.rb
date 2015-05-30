module Slugable

  def to_slug(str)
    str = str.squish.gsub(/[^A-Za-z0-9]/, '-').gsub(/-+/, '-').downcase
    self.slug = str
  end

  def check_slug_uniqueness(slug)
    count = 2
    temp_slug = slug

    loop do
      break if self.class.find_by_slug(temp_slug).nil?
      temp_slug = slug + "-#{count}"
      count += 1
    end

    self.slug = temp_slug
  end

end
