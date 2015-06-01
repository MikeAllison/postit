module Slugable

  def to_slug(str)
    str = str.squish.gsub(/[^A-Za-z0-9]/, '-').gsub(/-+/, '-').downcase
    self.slug = str
  end

  def check_slug_uniqueness(slug)
    count = 2

    loop do
      # Break the loop if no slug with the same value isn't found
      # Also break the loop if a slug with that value is found...
      # ...if it is the same object
      query = self.class.find_by_slug(slug)
      binding.pry
      break if query.nil?
      slug += "-#{count}"
      count += 1
    end

    self.slug = slug
  end

end
