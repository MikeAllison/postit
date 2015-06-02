module Slugable

  def to_slug(str)
    str.squish.gsub(/[^A-Za-z0-9]/, '-').gsub(/-+/, '-').downcase
  end

  def check_slug_uniqueness(post_title)
    count = 2
    slug = post_title

    loop do
      break if self.class.find_by(slug: slug).nil?
      slug = post_title + "-#{count}"
      count += 1
    end

    return slug
  end

end
